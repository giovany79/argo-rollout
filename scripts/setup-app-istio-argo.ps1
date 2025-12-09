Write-Host "=== Limpiando recursos anteriores si existen ==="
kubectl delete rollout rollouts-demo --ignore-not-found=true
kubectl delete svc rollouts-demo-stable rollouts-demo-canary --ignore-not-found=true
kubectl delete virtualservice rollouts-demo-vsvc rollouts-demo-vsvc1 rollouts-demo-vsvc2 --ignore-not-found=true
kubectl delete gateway rollouts-demo-gateway --ignore-not-found=true

Write-Host ""
Write-Host "=== Desplegando aplicación con Istio y Argo Rollouts ==="

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$K8S_DIR = Join-Path (Split-Path -Parent $SCRIPT_DIR) "k8s"

kubectl apply -f "$K8S_DIR\gateway.yaml"
kubectl apply -f "$K8S_DIR\services.yaml"
kubectl apply -f "$K8S_DIR\virtualsvc.yaml"
kubectl apply -f "$K8S_DIR\rollout.yaml"

Write-Host ""
Write-Host "=== Verificando el estado del Rollout ==="
kubectl argo rollouts get rollout rollouts-demo

Write-Host ""
Write-Host "=== Para ver el progreso en tiempo real, ejecuta: ==="
Write-Host "kubectl argo rollouts get rollout rollouts-demo --watch"
