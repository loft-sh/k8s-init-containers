# syntax = docker/dockerfile:latest
FROM alpine:latest

# argument for the local (workspace) directory to be copied to the contianer WORKDIR directory
ARG LD=bin
# argument for working directory in the container
ARG WD=/init-bin
# environment value for working directory in the container
ENV WD=${WD} 
# add working directory to the PATH environment value
ENV PATH=${WD}:$PATH

WORKDIR ${WD}

RUN apk add --no-cache redis postgresql-client curl git bash

ADD ${LD} .
RUN chmod +x .*

