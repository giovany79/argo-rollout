# argo-rollout

Herramienta de release que permite hacer rollout progresivo de tu aplicación.
Extiende los deployments de kubernetes con el objeto rollout.

## Diferencias con Argo CD
- Argo CD es una herramienta declarativa de GitOps usada para sincronizar configuraciones deseables en kubernetes
- Soporta Helm y Kustomize
- Compara los archivos del cluster con los archivos del repositorio de git
- La información de git es la fuente de la verdad
- Puede tener una sincronización automática o manual
  
![alt text](assets/image.png)

## GitOps
GitOps es una metodología de gestión de infraestructura y aplicaciones en la nube que utiliza Git como fuente única de verdad para la configuración y el despliegue.

En GitOps:

Todo el estado deseado del sistema (infraestructura, aplicaciones, configuraciones) se define en archivos declarativos (por ejemplo, YAML) y se almacena en un repositorio Git.
Los cambios se realizan mediante commits y pull requests en Git.
Herramientas como Argo CD o Flux observan el repositorio y sincronizan automáticamente el estado del cluster con lo que está definido en Git.

Ventajas:
- Auditoría y control de cambios
- Despliegues automáticos y reproducibles
- Facilidad para revertir cambios y mantener consistencia

## Prerequisitos

1. Docker Desktop instalado y corriendo
2. Git instalado
3. PowerShell 5.1 o superior
4. Repositorio en GitHub (opcional, se puede usar localmente)

## Instalación Rápida
1. Clonar el repositorio https://github.com/giovany79/argo-rollout
2. Crear en su cuenta de github repositorio propio con los archivos clonados

### Opción 1: Setup Automático Completo

```powershell
.\scripts\setup-all.ps1
```

Este script ejecuta automáticamente:
- Instalación de Minikube (si no está instalado)
- Configuración de Kubernetes con Istio
- Instalación de Argo CD
- Instalación de Argo Rollouts

### Opción 2: Instalación Paso a Paso

#### 1. Instalar Minikube y Docker
```powershell
.\scripts\install_minikube.ps1
```
Instala Minikube automáticamente si no está presente y lo inicia con Docker Desktop.

#### 2. Configurar Kubernetes e Istio
```powershell
.\scripts\setup_k8s_istio.ps1
```
Instala Istio con perfil demo y habilita inyección automática de sidecars.

#### 3. Instalar Argo CD
```powershell
.\scripts\setup-argo-cd.ps1
```
Instala Argo CD y descarga el CLI automáticamente. Muestra la contraseña inicial del admin.

#### 4. Instalar Argo Rollouts
```powershell
.\scripts\setup-argo-rollout.ps1
```
Instala Argo Rollouts y descarga el plugin kubectl-argo-rollouts.



## Desplegar tu Aplicación

### 1. Desplegar en Kubernetes
```powershell
.\scripts\setup-app-istio-argo.ps1
```
Despliega la aplicación con Istio y Argo Rollouts en el cluster de Minikube.

### 2. Registrar en Argo CD (Opcional)
```powershell
.\scripts\register-app-argocd.ps1
```
Registra la aplicación en Argo CD. Detecta automáticamente tu repositorio Git.

Para especificar manualmente:
```powershell
$env:REPO_URL="https://github.com/tu-usuario/tu-repo.git"
$env:APP_NAME="mi-app"
.\scripts\register-app-argocd.ps1
```

## Acceder a las Consolas

### Argo CD UI
```powershell
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
URL: https://localhost:8080
Usuario: admin
Password: 
```powershell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

### Argo Rollouts Dashboard
```powershell
kubectl argo rollouts dashboard
```
URL: http://localhost:3100

### Aplicación Rollout-demo

1. Crear túnel entre la máquina y el servicio dentro del cluster:
```powershell
minikube service istio-ingressgateway -n istio-system
```

2. Modificar el archivo hosts:
```powershell
notepad C:\Windows\System32\drivers\etc\hosts
```
Agregar al final:
```
127.0.0.1 rollouts-demo.local
```

3. Acceder a: http://rollouts-demo.local:PUERTO/

### Acceso Directo con Port-Forward
```powershell
.\scripts\access-app.ps1
```
URL: http://localhost:8081

## Comandos Útiles de Argo Rollouts

Ver el estado del rollout en tiempo real:
```powershell
kubectl argo rollouts get rollout rollouts-demo --watch
```

Cambiar la imagen (trigger de nuevo rollout):
```powershell
kubectl argo rollouts set image rollouts-demo rollouts-demo=argoproj/rollouts-demo:yellow
```

Promover el canary a stable:
```powershell
kubectl argo rollouts promote rollouts-demo
```

Abortar un rollout:
```powershell
kubectl argo rollouts abort rollouts-demo
```

Reintentar un rollout fallido:
```powershell
kubectl argo rollouts retry rollout rollouts-demo
```

Ver historial de revisiones:
```powershell
kubectl argo rollouts history rollout rollouts-demo
```

## Scripts Disponibles

| Script | Descripción |
|--------|-------------|
| `setup-all.ps1` | Instalación completa automática |
| `install_minikube.ps1` | Instala y configura Minikube con Docker |
| `setup_k8s_istio.ps1` | Instala Istio en el cluster |
| `setup-argo-cd.ps1` | Instala Argo CD y CLI |
| `setup-argo-rollout.ps1` | Instala Argo Rollouts y plugin |
| `generate-manifests.ps1` | Genera manifiestos desde config.yaml |
| `setup-app-istio-argo.ps1` | Despliega la aplicación |
| `register-app-argocd.ps1` | Registra app en Argo CD |
| `access-app.ps1` | Port-forward para acceso directo |

## Estructura del Proyecto

```
argo-rollout/
├── scripts/              # Scripts de PowerShell
│   ├── setup-all.ps1
│   ├── install_minikube.ps1
│   ├── setup_k8s_istio.ps1
│   ├── setup-argo-cd.ps1
│   ├── setup-argo-rollout.ps1
│   ├── generate-manifests.ps1
│   ├── setup-app-istio-argo.ps1
│   ├── register-app-argocd.ps1
│   └── access-app.ps1
├── k8s/                  # Manifiestos de Kubernetes
│   ├── rollout.yaml
│   ├── services.yaml
│   ├── gateway.yaml
│   ├── virtualsvc.yaml
│   ├── *.template        # Plantillas para personalizar
├── config.yaml           # Configuración de tu app
├── README.md             # Versión original para Mac
├── README-WINDOWS.md     # Esta guía para Windows
└── GUIA-PERSONALIZACION.md
```

## Troubleshooting

### Minikube no inicia
```powershell
minikube delete
minikube start --driver=docker
```

### Pods no están listos
```powershell
kubectl get pods -A
kubectl describe pod <pod-name> -n <namespace>
```

### Argo CD no sincroniza
```powershell
kubectl logs -n argocd deployment/argocd-repo-server
argocd app sync <app-name>
```

### Rollout atascado
```powershell
kubectl argo rollouts abort rollouts-demo
kubectl argo rollouts retry rollout rollouts-demo
```

## Links

Getting Started Argo Rollout with Istio: https://argo-rollouts.readthedocs.io/en/stable/getting-started/istio/

30 Days Of CNCF Projects | Day 9: What is Argo Rollouts + Demo:
https://www.youtube.com/watch?v=eAF1UsOqXYI

Argo Rollouts in 15 minutes!
https://www.youtube.com/watch?v=w3xdopP4aEk

ArgoCD Starter Guide: Full Tutorial for ArgoCD in Kubernetes:
https://www.youtube.com/watch?v=JLrR9RV9AFA
