# argo-rollout
1. Ejecutar 
   
   ```
   sh script/setup-all.sh
   ```

2. Instalar aplicacion
   
   ```
   sh scripts/setup-app-istio-argo.sh
    ```

3. Registrar aplicación en Argo CD
   
    ```
   sh scripts/register-app-argocd.sh
    ```

4. Abrir la aplicacion
   
    kubectl port-forward svc/rollouts-demo-stable 8081:80
    
   http://localhost:8081/

## Acceder a las Consolas

### Argo CD UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
URL: https://localhost:8080

### Argo Rollouts Dashboard
```bash
sh scripts/open-rollouts-dashboard.sh
```
URL: http://localhost:3100

## Comandos útiles de Argo Rollouts

5. Ver el rollout

kubectl argo rollouts get rollout rollouts-demo --watch

6. Promover
   
   kubectl argo rollouts promote rollouts-demo