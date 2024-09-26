#minikube start
minikube start -p argocd --cpus=8 --disk-size=40gb --memory=16gb --extra-config=kubelet.max-pods=6000

minikube start  -p argocd --nodes=4 --cpus=4 --memory=4gb --driver=docker --extra-config=kubelet.max-pods=2000

minikube addons enable metrics-server -p argocd

#argocd operator install
https://argocd-operator.readthedocs.io/en/latest/install/olm/

#argocd install
https://argocd-operator.readthedocs.io/en/latest/usage/basics/

#argocd port-forward
kubectl port-forward svc/example-argocd-server -n argocd 8080:443

#make script executable
chmod +x ./argo-app-create.bash 
#make script executable
chmod +x ./argo-app-delete.bash 

#create and apply apps
./argo-app-create.bash 1 1000 first
 k apply -f ./app-manifests/first -n argocd      

#delete all applications
argocd app list -o name | xargs -n 1 argocd app delete --yes --cascade
kubectl delete applications --all -n argocd
