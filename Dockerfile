FROM ubuntu:22.04

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  easy-rsa && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/ca-service/easy-rsa
RUN mkdir -p /tmp/ca-service/

RUN ln -s /usr/share/easy-rsa/* /tmp/ca-service/easy-rsa/

COPY vars /tmp/ca-service/

WORKDIR /tmp/ca-service
