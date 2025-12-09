Write-Host "=== Registrando aplicación en Argo CD ==="

kubectl get namespace argocd 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Argo CD no está instalado. Ejecuta primero: .\scripts\setup-argo-cd.ps1"
    exit 1
}

$APP_NAME = if ($env:APP_NAME) { $env:APP_NAME } else { "rollouts-demo" }
$NAMESPACE = if ($env:NAMESPACE) { $env:NAMESPACE } else { "default" }
$APP_PATH = if ($env:APP_PATH) { $env:APP_PATH } else { "k8s" }
$TARGET_REVISION = if ($env:TARGET_REVISION) { $env:TARGET_REVISION } else { "main" }

if ($env:REPO_URL) {
    $REPO_URL = $env:REPO_URL
} else {
    Write-Host "Detectando repositorio Git..."
    $gitRemote = git remote get-url origin 2>$null
    if ($LASTEXITCODE -eq 0 -and $gitRemote) {
        $REPO_URL = $gitRemote
        Write-Host "Repositorio detectado: $REPO_URL"
    } else {
        Write-Host "No se pudo detectar el repositorio Git."
        Write-Host "Por favor configura la variable de entorno REPO_URL:"
        Write-Host '  $env:REPO_URL="https://github.com/tu-usuario/tu-repo.git"'
        Write-Host "O ejecuta desde un directorio con Git inicializado"
        exit 1
    }
}

Write-Host "Creando aplicación: $APP_NAME"
Write-Host "Repositorio: $REPO_URL"
Write-Host "Rama: $TARGET_REVISION"
Write-Host "Path: $APP_PATH"
Write-Host ""

$manifest = @"
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
"@

$manifest | kubectl apply -f -

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Aplicación registrada exitosamente ==="
    Write-Host ""
    Write-Host "Para ver el estado de la aplicación:"
    Write-Host "  kubectl get application $APP_NAME -n argocd"
    Write-Host ""
    Write-Host "Para acceder a Argo CD UI:"
    Write-Host "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    Write-Host "  URL: https://localhost:8080"
    Write-Host "  Usuario: admin"
    Write-Host "  Obtener password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`$_)) }"
    Write-Host ""
    Write-Host "Para sincronizar manualmente:"
    Write-Host "  argocd app sync $APP_NAME"
} else {
    Write-Host "Error al registrar la aplicación en Argo CD"
    exit 1
}
