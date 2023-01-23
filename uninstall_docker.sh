#!/bin/bash

# Stop and remove all running Docker containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Uninstall the Docker packages
sudo apt-get remove -y docker-ce docker-ce-cli containerd.io

# Remove the Docker data directory
sudo rm -rf /var/lib/docker

# Remove the Docker group
#sudo groupdel docker

# Remove any lingering Docker images, networks, and volumes
docker rmi $(docker images -q)
docker network rm $(docker network ls -q)
docker volume rm $(docker volume ls -q)
