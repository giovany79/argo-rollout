#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

sh "$SCRIPT_DIR/install_minikube.sh"

sh "$SCRIPT_DIR/setup_k8s_istio.sh"

sh "$SCRIPT_DIR/setup-argo-cd.sh"

sh "$SCRIPT_DIR/setup-argo-rollout.sh"