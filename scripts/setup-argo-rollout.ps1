kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
$env:Path += ";$env:USERPROFILE"
kubectl argo rollouts version
if (!(Get-Command kubectl-argo-rollouts -ErrorAction SilentlyContinue)) {
    Write-Host "Descargando kubectl-argo-rollouts plugin..."
    
    try {
        $url = "https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-windows-amd64"
        $pluginPath = "$env:USERPROFILE\kubectl-argo-rollouts.exe"
        
        Write-Host "Descargando desde: $url"
        Invoke-WebRequest -Uri $url -OutFile $pluginPath -UseBasicParsing
        
        Write-Host "kubectl-argo-rollouts descargado en $pluginPath"
        Write-Host "Agrega $env:USERPROFILE al PATH para usar 'kubectl argo rollouts' desde cualquier lugar"
    }
    catch {
        Write-Host "Error al descargar kubectl-argo-rollouts: $_"
        Write-Host "Puedes descargarlo manualmente desde: https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-windows-amd64"
    }
}
