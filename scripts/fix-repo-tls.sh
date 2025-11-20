#!/bin/bash

echo "=== Eliminando la aplicación actual ==="
kubectl delete application rollouts-demo -n argocd

echo ""
echo "=== Configurando el repositorio como inseguro en Argo CD ==="

# Crear un Secret para el repositorio con la opción insecure
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: repo-github-giovany79
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/giovany79/argo-rollout.git
  insecure: "true"
EOF

echo ""
echo "=== Esperando 5 segundos ==="
sleep 5

echo ""
echo "=== Recreando la aplicación con el repositorio configurado ==="
kubectl apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: rollouts-demo
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/giovany79/argo-rollout.git
    targetRevision: main
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
EOF

echo ""
echo "=== Esperando sincronización ==="
sleep 10

echo ""
echo "=== Estado de la aplicación ==="
kubectl get application rollouts-demo -n argocd
echo ""
kubectl describe application rollouts-demo -n argocd | grep -A 10 "Status:"

echo ""
echo "=== Listo! Verifica en: https://localhost:8080 ==="
