FROM ubuntu:22.04

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  easy-rsa && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/easy-rsa
WORKDIR /tmp/easy-rsa
RUN ln -s /usr/share/easy-rsa/* /tmp/easy-rsa/
RUN ./easyrsa init-pki
