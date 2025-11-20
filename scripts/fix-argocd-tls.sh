#!/bin/bash

echo "=== Configurando Argo CD para permitir repositorios inseguros ==="

# Configurar Argo CD para ser más permisivo con TLS para GitHub
kubectl patch configmap argocd-cm -n argocd --type merge -p '{
  "data": {
    "repository.credentials": "- url: https://github.com\n  insecure: \"true\""
  }
}'

echo ""
echo "=== Reiniciando componentes de Argo CD para aplicar cambios ==="
kubectl rollout restart deployment argocd-repo-server -n argocd
kubectl rollout restart deployment argocd-server -n argocd

echo ""
echo "=== Esperando a que los pods se reinicien ==="
kubectl rollout status deployment argocd-repo-server -n argocd
kubectl rollout status deployment argocd-server -n argocd

echo ""
echo "=== Esperando 10 segundos para que los cambios se apliquen ==="
sleep 10

echo ""
echo "=== Forzando sincronización de la aplicación ==="
kubectl patch application rollouts-demo -n argocd --type merge -p '{"operation": {"initiatedBy": {"username": "admin"}, "sync": {"revision": "main"}}}'

echo ""
echo "=== Verificando el estado de la aplicación ==="
kubectl get application rollouts-demo -n argocd -o jsonpath='{.status.sync.status}' && echo ""
kubectl get application rollouts-demo -n argocd -o jsonpath='{.status.health.status}' && echo ""

echo ""
echo "=== Configuración completada ==="
echo "Verifica el estado de la aplicación en: https://localhost:8080"
echo ""
echo "Para ver los detalles de la aplicación:"
echo "  kubectl describe application rollouts-demo -n argocd"
