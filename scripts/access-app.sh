#!/bin/bash

echo "=== Accediendo a la aplicación Rollouts Demo ==="
echo ""
echo "La aplicación estará disponible en: http://localhost:8081"
echo ""
echo "Presiona Ctrl+C para detener el port-forward"
echo ""

kubectl port-forward svc/rollouts-demo-stable 8081:80
