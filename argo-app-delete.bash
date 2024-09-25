#!/bin/bash

# ArgoCD server address
ARGOCD_SERVER="localhost:8080"
# ArgoCD username and password
ARGOCD_USERNAME="admin"
ARGOCD_PASSWORD=$(kubectl -n argocd get secret example-argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d)

# Login to ArgoCD
argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --insecure

# Namespace for applications
NAMESPACE="default"
# Repo URL and Path
REPO_URL="https://github.com/canpolato/argo-poc.git"
APP_PATH="helm-charts/pause"
# Destination cluster and namespace
DEST_SERVER="https://kubernetes.default.svc"
DEST_NAMESPACE="default"

APP_COUNT=5

for i in $(seq 1 $APP_COUNT);
do
  APP_NAME="app-$i"
  argocd app delete $APP_NAME \
    --yes
  echo "Deleted application: $APP_NAME"
done

# Log out after the process
argocd logout $ARGOCD_SERVER
