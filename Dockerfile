FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

RUN apt-get update && apt-get install -y \
    sqlplus \
    git \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://download.oracle.com/otn_software/linux/instantclient/2113000/instantclient-basic-linux.x64-21.13.0.0.0dbru.zip \
    && unzip instantclient-basic-linux.x64-21.13.0.0.0dbru.zip -d /opt/ \
    && rm instantclient-basic-linux.x64-21.13.0.0.0dbru.zip

ENV LD_LIBRARY_PATH=/opt/instantclient_21_13:$LD_LIBRARY_PATH
ENV PATH=$PATH:/opt/instantclient_21_13

WORKDIR /workspace
