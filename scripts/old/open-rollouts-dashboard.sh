#!/bin/bash

echo "=== Iniciando Argo Rollouts Dashboard ==="
echo ""
echo "El dashboard se abrirá en: http://localhost:3100"
echo ""
echo "Presiona Ctrl+C para detener el dashboard"
echo ""

kubectl argo rollouts dashboard
