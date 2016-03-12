#!/bin/bash

DOCKER_MACHINE_NAME=fusion
DOCKER_MACHINE_STATE=`docker-machine ls | awk -v DOCKER_MACHINE_NAME="$DOCKER_MACHINE_NAME" '$1 == DOCKER_MACHINE_NAME {print $4}'`
if [ "$DOCKER_MACHINE_STATE" != "Running" ]; then
  docker-machine start $DOCKER_MACHINE_NAME
fi
eval "$(docker-machine env $DOCKER_MACHINE_NAME)"
export DOCKER_MACHINE_IP=`docker-machine ip $DOCKER_MACHINE_NAME`

SELENIUM_CONTAINER=`docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:2.52.0`

node index.js

docker stop $SELENIUM_CONTAINER
docker rm $SELENIUM_CONTAINER
docker ps -a