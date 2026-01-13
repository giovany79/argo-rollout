#!/bin/bash

echo "=== Limpiando recursos anteriores si existen ==="
kubectl delete rollout rollouts-demo --ignore-not-found=true
kubectl delete svc rollouts-demo-stable rollouts-demo-canary --ignore-not-found=true
kubectl delete virtualservice rollouts-demo-vsvc rollouts-demo-vsvc1 rollouts-demo-vsvc2 --ignore-not-found=true
kubectl delete gateway rollouts-demo-gateway --ignore-not-found=true

echo ""
echo "=== Desplegando aplicación con Istio y Argo Rollouts ==="

# Get the script directory and set the k8s path
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
K8S_DIR="$(dirname "$SCRIPT_DIR")/k8s"

# Aplicar manifiestos
kubectl apply -f "$K8S_DIR/gateway.yaml"
kubectl apply -f "$K8S_DIR/services.yaml"
kubectl apply -f "$K8S_DIR/virtualsvc.yaml"
kubectl apply -f "$K8S_DIR/rollout.yaml"

echo ""
echo "=== Verificando el estado del Rollout ==="
kubectl argo rollouts get rollout rollouts-demo

echo ""
echo "=== Para ver el progreso en tiempo real, ejecuta: ==="
echo "kubectl argo rollouts get rollout rollouts-demo --watch"