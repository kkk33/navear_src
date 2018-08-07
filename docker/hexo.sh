#!/bin/bash

# config
ROOT="$PWD/`dirname $0`/.."
ROOT_HEXO="$ROOT/hexo"
KEY_FILE="$ROOT_HEXO/docker/key"
HEXO_DOCKER_IMG='hexo_docker'
HEXO_DOCKER_EXPOSE='4000'
ROOT_DOCKER="$ROOT/docker"
ROOT_SSH="$HOME/.ssh"


# function 
function IsImageExisting()
{
    local f=`docker images|awk -v docker_name="$HEXO_DOCKER_IMG" '{if($1==docker_name)print $1}'`
    if [[ "x" == "${f}x" ]] ;then
        return 1
    else
        return 0
    fi
}

function hexo_build()
{
    # is existing?
    IsImageExisting
    if [[ 0 == $? ]] ;then
        echo 'image is existing'
        return 0
    fi

    # build it.
    docker build -t $HEXO_DOCKER_IMG -f "$ROOT_DOCKER/Dockerfile" "$ROOT"

    # build failed?
    IsImageExisting
    if [[ 0 == $? ]] ;then
        echo 'build success'
        return 0
    else
        echo 'build failed'
        return 1
    fi
}

function hexo_init()
{
    IsImageExisting && docker run -v $ROOT_HEXO:/hexo $HEXO_DOCKER_IMG hexo init
}

function hexo_server()
{
    IsImageExisting && docker run -v $ROOT_HEXO:/hexo -p $HEXO_DOCKER_EXPOSE:4000 $HEXO_DOCKER_IMG hexo server
}

function hexo_deploy()
{
    IsImageExisting && \
        docker run \
        -v $ROOT_HEXO:/hexo \
        -v $ROOT_SSH:/root/.ssh \
        $HEXO_DOCKER_IMG hexo d -g
}


alias hexo_docker="IsImageExisting && \
        docker run \
        -v $ROOT_HEXO:/hexo \
        -v $ROOT_SSH:/root/.ssh \
        $HEXO_DOCKER_IMG "
