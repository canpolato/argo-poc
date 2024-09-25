#minikube start
minikube start -p argocd --cpus=4 --disk-size=40gb --memory=20gb

#argocd operator install
https://argocd-operator.readthedocs.io/en/latest/install/olm/

#argocd install
https://argocd-operator.readthedocs.io/en/latest/usage/basics/

#argocd port-forward
kubectl port-forward svc/example-argocd-server -n argocd 8080:443

#make script executable
chmod +x ./argo-app-create.bash 

