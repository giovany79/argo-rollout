$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

& "$SCRIPT_DIR\install_minikube.ps1"

& "$SCRIPT_DIR\setup_k8s_istio.ps1"

& "$SCRIPT_DIR\setup-argo-cd.ps1"

& "$SCRIPT_DIR\setup-argo-rollout.ps1"
