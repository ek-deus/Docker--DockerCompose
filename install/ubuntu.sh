#!/bin/sh

set -o errexit
set -o nounset

IFS=$(printf '\n\t')

# Установка Docker
#sudo apt remove --yes docker docker-engine docker.io containerd runc
sudo apt update
sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
sudo apt update
sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker "$USER"
sudo systemctl enable docker
printf '\nDocker установлен\n\n'

printf 'Ждем запуска Docker...\n\n'
sleep 5

# Установка Docker Compose
sudo wget --output-document=/usr/local/bin/docker-compose \
"https://github.com/docker/compose/releases/download/$(wget --quiet \
--output-document=- https://api.github.com/repos/docker/compose/releases/latest \
| grep --perl-regexp --only-matching '"tag_name": "\K.*?(?=")')/run.sh"
sudo chmod +x /usr/local/bin/docker-compose
sudo wget --output-document=/etc/bash_completion.d/docker-compose \
"https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose"

# Docker Compose
#compose_release() {
#  sudo curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
#  sudo grep -Po '"tag_name": "\K.*?(?=")'
#}

#if ! [ -x "$(command -v docker-compose)" ]; then
#  curl -L https://github.com/docker/compose/releases/download/$(compose_release)/docker-compose-$(uname -s)-$(uname -m) \
#  -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
#fi

printf '\nDocker Compose установлен\n\n'
