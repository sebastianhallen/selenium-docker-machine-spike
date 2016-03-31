#!/bin/bash

source prerequisites.sh

SELENIUM_CONTAINER=`docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:2.52.0`

node index.js

docker stop $SELENIUM_CONTAINER
docker rm $SELENIUM_CONTAINER
docker ps -a