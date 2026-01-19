Write-Host "Installing Argo CD..."

kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Write-Host "Waiting for Argo CD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

if (!(Get-Command argocd -ErrorAction SilentlyContinue)) {
    Write-Host "Descargando Argo CD CLI..."
    $version = (Invoke-RestMethod https://api.github.com/repos/argoproj/argo-cd/releases/latest).tag_name
    $url = "https://github.com/argoproj/argo-cd/releases/download/$version/argocd-windows-amd64.exe"
    Invoke-WebRequest -Uri $url -OutFile "$env:USERPROFILE\argocd.exe"
    Write-Host "Argo CD CLI descargado en $env:USERPROFILE\argocd.exe"
    Write-Host "Agrega $env:USERPROFILE al PATH para usar 'argocd' desde cualquier lugar"
}

Write-Host "Argo CD installation complete!"
Write-Host ""
Write-Host "To access Argo CD UI:"
Write-Host "1. Port forward: kubectl port-forward svc/argocd-server -n argocd 8080:443"
Write-Host "2. Get initial admin password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }"
Write-Host "3. Access UI at: https://localhost:8080"
Write-Host "4. Username: admin"

$password = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}'
$decodedPassword = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($password))
Write-Host $decodedPassword

Write-Host ""
Write-Host "=== Configurando Argo CD para permitir repositorios inseguros ==="

$patchData = @'
{
  "data": {
    "repository.credentials": "- url: https://github.com\n  insecure: \"true\""
  }
}
'@

$patchData | kubectl patch configmap argocd-cm -n argocd --type merge -p -

Write-Host ""
Write-Host "=== Reiniciando componentes de Argo CD para aplicar cambios ==="
kubectl rollout restart deployment argocd-repo-server -n argocd
kubectl rollout restart deployment argocd-server -n argocd

Write-Host ""
Write-Host "=== Esperando a que los pods se reinicien ==="
kubectl rollout status deployment argocd-repo-server -n argocd
kubectl rollout status deployment argocd-server -n argocd

Write-Host ""
Write-Host "=== Esperando 10 segundos para que los cambios se apliquen ==="
Start-Sleep -Seconds 10
