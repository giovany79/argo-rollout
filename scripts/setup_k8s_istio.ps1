Write-Host "3. Setup istio system"
Write-Host "-------------------------"
istioctl
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled

Write-Host "4. Sleep 60 seconds"
Write-Host "-------------------------"
Start-Sleep -Seconds 60

Write-Host "5. Get pods from istio-system namespace"
Write-Host "-------------------------"
kubectl get po -n istio-system
