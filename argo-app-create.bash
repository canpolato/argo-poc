#!/bin/bash

# ArgoCD server address
ARGOCD_SERVER="your-argocd-server.com"
# ArgoCD username and password
ARGOCD_USERNAME="admin"
ARGOCD_PASSWORD=$(kubectl -n argocd get secret example-argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d)

# Login to ArgoCD
argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --insecure

# Namespace for applications
NAMESPACE="default"
# Repo URL and Path
REPO_URL="https://github.com/your-repo.git"
APP_PATH="path-to-application"
# Destination cluster and namespace
DEST_SERVER="https://kubernetes.default.svc"
DEST_NAMESPACE="default"

# Loop to create 10000 applications
for i in {1..10000}
do
  APP_NAME="app-$i"
  argocd app create $APP_NAME \
    --repo $REPO_URL \
    --path $APP_PATH \
    --dest-server $DEST_SERVER \
    --dest-namespace $DEST_NAMESPACE \
    --sync-policy none \
    --self-heal
  echo "Created application: $APP_NAME"
done

# Log out after the process
argocd logout $ARGOCD_SERVER
