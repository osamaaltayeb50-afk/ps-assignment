#!/bin/bash
# install K3s (single node, it is both master and worker) and run the sample deployment
curl -sfL https://get.k3s.io | sh -

sudo k3s kubectl get nodes -o wide          # the ROLES column shows control-plane
sudo k3s kubectl apply -f nginx-deployment.yaml
sudo k3s kubectl get deployments,pods,svc
curl -I http://localhost:30080
