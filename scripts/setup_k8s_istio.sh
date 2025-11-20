#!/bin/bash
echo "3. Setup istio system"
# shellcheck disable=SC1073
echo "-------------------------"
istioctl
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled

echo "4. Sleep 60 seconds"
# shellcheck disable=SC1073
echo "-------------------------"
sleep 60

echo "5. Get pods from istio-system namespace"
# shellcheck disable=SC1073
echo "-------------------------"
kubectl get po -n istio-system