#!/bin/bash

echo "=== Registrando aplicación en Argo CD ==="

# Verificar si Argo CD está instalado
kubectl get namespace argocd >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Argo CD no está instalado. Ejecuta primero: sh scripts/setup-argo-cd.sh"
    exit 1
fi

# Configurar variables
APP_NAME="rollouts-demo"
NAMESPACE="default"
REPO_URL="${REPO_URL:-https://github.com/giovany79/argo-rollout.git}"
TARGET_REVISION="${TARGET_REVISION:-main}"
APP_PATH="${APP_PATH:-k8s}"

echo "Creando aplicación: $APP_NAME"
echo "Repositorio: $REPO_URL"
echo "Rama: $TARGET_REVISION"
echo "Path: $APP_PATH"
echo ""

# Crear la aplicación en Argo CD
kubectl apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $APP_NAME
  namespace: argocd
spec:
  project: default
  source:
    repoURL: $REPO_URL
    targetRevision: $TARGET_REVISION
    path: $APP_PATH
  destination:
    server: https://kubernetes.default.svc
    namespace: $NAMESPACE
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "=== Aplicación registrada exitosamente ==="
    echo ""
    echo "Para ver el estado de la aplicación:"
    echo "  kubectl get application $APP_NAME -n argocd"
    echo ""
    echo "Para acceder a Argo CD UI:"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "  URL: https://localhost:8080"
    echo "  Usuario: admin"
    echo "  Obtener password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
    echo ""
    echo "Para sincronizar manualmente:"
    echo "  argocd app sync $APP_NAME"
else
    echo "Error al registrar la aplicación en Argo CD"
    exit 1
fi
