#!/bin/bash

function docker_compose()
{
    #install docker compose
    echo -e "\n\e[1;32m Installing docker compose \e[0m\n"
    sudo docker-compose up -d
    echo -e "\n\e[1;32m docker compose installation successful \e[0m\n"
    docker compose run --rm proxy wait-for-it.sh ng-manager:7090 -t 180
}

function install_cd_comm()
{
    #git clone
    echo -e "\n\e[1;32m Cloning cd-community repository \e[0m\n"
    git clone https://github.com/harness/harness-cd-community.git
    cd harness-cd-community/docker-compose/harness

    # Install docker compose
    echo -e "\n\e[1;32m Starting docker compose with 3GB Ram and 2 cpu \e[0m\n"
    docker_compose
}

echo -e "\n\e[1;32m Thanks for installing Harness CD community \e[0m\n"

install_cd_comm
