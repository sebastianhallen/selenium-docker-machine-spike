#!/bin/bash

function ensure-docker-machine() {
  echo >&2 "checking that docker-machine is installed";
  hash docker-machine 2>/dev/null || {
    echo >&2 "docker-machine not installed, please install it first";
    exit 1;
  }

  DOCKER_MACHINE_NAME=fusion
  DOCKER_MACHINE_STATE=`docker-machine ls | awk -v DOCKER_MACHINE_NAME="$DOCKER_MACHINE_NAME" '$1 == DOCKER_MACHINE_NAME {print $4}'`
  if [ "$DOCKER_MACHINE_STATE" != "Running" ]; then
    docker-machine start $DOCKER_MACHINE_NAME
  fi
  eval "$(docker-machine env $DOCKER_MACHINE_NAME)"
  export DOCKER_MACHINE_IP=`docker-machine ip $DOCKER_MACHINE_NAME`
}

function ensure-node() {
  echo >&2 "checking that node is installed";
  hash node 2>/dev/null || {
    echo >&2 "nodejs not installed, checking for nvm"
    if [ -f ~/.nvm/nvm.sh ]; then
      echo >&2 "nvm present, installing node";
      source ~/.nvm/nvm.sh
      nvm install node;
    else
      echo >&2 "nvm not present - can't install node, exiting";
      exit 1;
    fi
  }
}

function ensure-prerequisites() {
  ensure-docker-machine
  ensure-node
}

ensure-prerequisites