#!/bin/bash

function install_docker_ubuntu()
{
#Install Docker
    echo -e "\n\e[1;32m Installing Docker \e[0m\n"
    sudo apt-get update
    sudo apt-get install vim git -y
    sudo apt-get install ca-certificates curl gnupg lsb-release -y 
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    echo -e "\n\e[1;32m Add your user to the 'docker' group: After this script execution. Use this command :  sudo usermod -aG docker $USER && newgrp docker \e[0m\n"
    echo -e "\n\e[1;32m Docker installation successful \e[0m\n"
}

install_docker_ubuntu

: << COMMENT
install_docker_fedora() {
    # Install and Enable Docker on Fedora distribution
    dnf -y install dnf-plugins-core
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    systemctl enable docker; systemctl start docker
}

install_docker_centos() {
    # Install and Enable Docker on CentOS, AlmaLinux, and RockyLinux distributions
    dnf -y install yum-utils
    dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    systemctl enable docker; systemctl start docker
}

install_docker_debian() {
    # Install and Enable Docker on Debian-based distributions
    apt-get update
    apt-get install ca-certificates curl gnupg lsb-release -y
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    chmod a+r /etc/apt/keyrings/docker.gpg
    apt-get update
    apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    systemctl enable docker; systemctl start docker
}


install_docker() {
    # Check the Linux distribution
    if [ -f /etc/redhat-release ]; then
        # Red Hat-based distribution
        install_docker_centos
    elif [ -f /etc/fedora-release ]; then
        # Fedora distribution
        install_docker_fedora
    elif [ -f /etc/lsb-release ]; then
        # Ubuntu-based distribution
        install_docker_ubuntu
    elif [ -f /etc/debian_version ]; then
        # Debian-based distribution
        install_docker_debian
    else
        echo "Error: Docker is not installed."
        return 1
    fi
}
COMMENT
