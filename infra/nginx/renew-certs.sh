#!/bin/bash

COMPOSE="/usr/local/bin/docker-compose --no-ansi"
DOCKER="/usr/bin/docker"

cd /home/senyo/blog/infra/docker-compose
$COMPOSE run certbot renew && $COMPOSE kill -s SIGHUP blog
$DOCKER system prune -af