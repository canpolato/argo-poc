#!/bin/bash

# Accessing parameters
START_COUNT=$1
END_COUNT=$2
FOLDER=$3

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

mkdir -p app-manifests/$FOLDER

for i in $(seq $START_COUNT $END_COUNT);
do
  APP_NAME="app-$i"

  argocd admin app generate-spec $APP_NAME \
    --repo $REPO_URL \
    --path $APP_PATH \
    --dest-server $DEST_SERVER \
    --dest-namespace $APP_NAME \
    --sync-policy automated \
    --sync-option Prune=true \
    --sync-option CreateNamespace=true \
    > app-manifests/$FOLDER/$APP_NAME.yaml
  echo "Generated spec: $APP_NAME"

  # argocd app create $APP_NAME \
  #   --repo $REPO_URL \
  #   --path $APP_PATH \
  #   --dest-server $DEST_SERVER \
  #   --dest-namespace $APP_NAME \
  #   --app-namespace argocd \
  #   --sync-policy automated \
  #   --sync-option Prune=true \
  #   --sync-option CreateNamespace=true
  # echo "Created application: $APP_NAME"

  # argocd --grpc-web app patch "$APP_NAME" --type merge --patch '{"spec": {"syncPolicy": {"managedNamespaceMetadata": {"labels": {"argocd.argoproj.io/managed-by": "example-argocd"}}}}}'
  # echo "Patched application: $APP_NAME"

done

# Log out after the process
argocd logout $ARGOCD_SERVER
