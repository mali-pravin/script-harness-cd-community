#!/bin/bash

function install_kubectl()
{
    #install kubectl 
    echo -e "\n\e[1;32m Installing kubectl \e[0m\n"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    kubectl version
    echo -e "\n\e[1;32m kubectl installation successful \e[0m\n"
}

function install_minikube()
{
    #install minikube
    echo -e "\n\e[1;32m Installing minikube \e[0m\n"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    minikube version
    echo -e "\n\e[1;32m minikube installation successful \e[0m\n"
}

function install_helm()
{
    # Install Helm
    echo -e "\n\e[1;32m Installing Helm \e[0m\n"
    wget https://get.helm.sh/helm-v3.11.0-linux-amd64.tar.gz
    tar -xvf helm-v3.11.0-linux-amd64.tar.gz
    sudo mv linux-amd64/helm /usr/local/bin/helm
    echo -e "\n\e[1;32m Helm installation successful \e[0m\n"
}

function install_cd_comm()
{
    #git clone
    echo -e "\n\e[1;32m Cloning cd-community repository \e[0m\n"
    git clone https://github.com/harness/harness-cd-community.git
    cd harness-cd-community/helm

    # Start minikube
    echo -e "\n\e[1;32m Starting minikube with 4GB Ram and 4 cpu \e[0m\n"
    minikube start --memory 4g --cpus 4

    #Start Harness CD using the helm-chart
    echo -e "\n\e[1;32m Installing Harness cd-community version using helm chart \e[0m\n"
    helm install harness ./harness --create-namespace --namespace harness

    for i in {1..6}
    do
        STR=$(kubectl get pods -n harness |grep ng-manager)
        SUB='Running'
            if [[ "$STR" == *"$SUB"* ]]; then
              echo -e "\n\e[1;32m ng-manager Status is Running \e[0m\n"
              else
              echo -e "\n\e[1;32m ng-manager Status is NOT Running \e[0m\n"
            fi
        echo -e "\n\e[1;32m Waiting ng-manager to UP and running..... \e[0m\n"
        sleep 30s
    done

kubectl wait --namespace harness --timeout 900s --selector app=proxy --for condition=Ready pods

ip=$(ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
echo -e "\n\e[1;32m Harness CD community version installed successfully \e[0m\n"
kubectl port-forward --namespace harness --address $ip svc/proxy 7143:80 9879:9879
}

echo -e "\n\e[1;32m Thanks for installing Harness CD community \e[0m\n"
install_kubectl
install_helm
install_minikube
install_cd_comm
