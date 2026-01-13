# argo-rollout

- Herramienta  de release que permite hacer rollout progresivo de tu aplicacion
- Extiende los deployments de kubernetes con el objeto rollout

## Diferencias con Argo CD
- Argo CD es una herramienta declarativa de GitOps usada para sincronizar configuraciones deseables en kubernetes
- Soporta Helm y Kustomize
- Compara los archivos del cluster con los archivos del repositorio de git
- La información de git es la fuente de la verdad
- Puede tener una sincronizacion automatica o manual
  
![alt text](assets/image.png)

## GitOps
GitOps es una metodología de gestión de infraestructura y aplicaciones en la nube que utiliza Git como fuente única de verdad para la configuración y el despliegue.

En GitOps:

Todo el estado deseado del sistema (infraestructura, aplicaciones, configuraciones) se define en archivos declarativos (por ejemplo, YAML) y se almacena en un repositorio Git.
Los cambios se realizan mediante commits y pull requests en Git.
Herramientas como Argo CD o Flux observan el repositorio y sincronizan automáticamente el estado del cluster con lo que está definido en Git.
Ventajas:

Auditoría y control de cambios.
Despliegues automáticos y reproducibles.
Facilidad para revertir cambios y mantener consistencia.

## Prerequisitos

1. Minikube instalado
2. Podman instalado
3. Repositorio en github
4. brew instalado
