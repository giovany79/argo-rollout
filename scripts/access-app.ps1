Write-Host "=== Accediendo a la aplicación Rollouts Demo ==="
Write-Host ""
Write-Host "La aplicación estará disponible en: http://localhost:8081"
Write-Host ""
Write-Host "Presiona Ctrl+C para detener el port-forward"
Write-Host ""

kubectl port-forward svc/rollouts-demo-stable 8081:80
