#!/bin/bash

# ПЕРЕД УСТАНОВКОЙ ЗАМЕНИТЬ РЕЛИЗ КОМПОЗА НА ТЕКУЩУЮ ВЕРСИЮ!!!
# Номер релиза брать тут: https://github.com/docker/compose/releases
COMPOSE-RELEASE=1.28.2

#Апдейтим
sudo yum check-update

# Устанавливаем Docker
curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo systemctl enable docker
echo "\nDocker установлен\n\n"

# Убираем "sudo" при использовании Docker для пользователя.
sudo usermod -aG docker $(whoami)

# Устанавливаем Docker Compose
sudo curl -L \
 "https://github.com/docker/compose/releases/download/$COMPOSE-RELEASE/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose

# Изменяем права на запуск
sudo chmod +x /usr/local/bin/docker-compose

# Выводим версию композа
docker-compose --version

echo "\nDocker Compose установлен\n\n"
