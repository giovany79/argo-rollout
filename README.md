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



## Acceder a las Consolas

### Argo CD UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
URL: https://localhost:8080

### Argo Rollouts Dashboard
```bash
kubectl argo rollouts dashboard
```
URL: http://localhost:3100


### Aplicacion Rollout-demo

```bash
kubectl port-forward svc/rollouts-demo-stable 8081:80
```
URL: http://localhost:8081

## Comandos útiles de Argo Rollouts

Ver el rollout

kubectl argo rollouts get rollout rollouts-demo --watch

Promover
   
   kubectl argo rollouts promote rollouts-demo

## Links

Getting Started Argo Rollout with istio: https://argo-rollouts.readthedocs.io/en/stable/getting-started/istio/