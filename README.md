# argo-rollout

- Herramienta  de release que permite hacer rollout progresivo de tu aplicacion
- Extiende los deployments de kubernetes con el objeto rollout

## Diferencias con Argo CD
- Argo CD es una herramienta GitOps usada para sincronizar configuraciones deseables en kubernetes
- Soporta Helm y Kustomize
  
![alt text](assets/image.png)


## Prerequisitos

1. Minikube instalado
2. Podman instalado
3. Repositorio en github
   
## Paso a paso

1. Clonar el repositorio https://github.com/giovany79/argo-rollout

2. Crear en su cuenta de github repositorio propio con los archivos clonados

3. Ejecutar 
   
   ```
   sh script/setup-all.sh
   ```

4. Instalar aplicacion
   
   ```
   sh scripts/setup-app-istio-argo.sh
    ```

5. Registrar aplicación en Argo CD
   
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

Crea tunel entre la maquina y el servicio dentro del cluster de minikube
```bash
minikube service istio-ingressgateway -n istio-system
```

Modificar el host
```bash
sudo nano /etc/hosts
```
Agregar la linea al final del archivo
127.0.0.1 rollouts-demo.local


URL: http://rollouts-demo.local:53279/

## Comandos útiles de Argo Rollouts

Ver el rollout

kubectl argo rollouts get rollout rollouts-demo --watch


Cambiar la imagen

kubectl argo rollouts set image rollouts-demo rollouts-demo=argoproj/rollouts-demo:yellow


Promover
   
   kubectl argo rollouts promote rollouts-demo

## Links

Getting Started Argo Rollout with istio: https://argo-rollouts.readthedocs.io/en/stable/getting-started/istio/

30 Days Of CNCF Projects | Day 9: What is Argo Rollouts + Demo:
https://www.youtube.com/watch?v=eAF1UsOqXYI

Argo Rollouts in 15 minutes!
https://www.youtube.com/watch?v=w3xdopP4aEk