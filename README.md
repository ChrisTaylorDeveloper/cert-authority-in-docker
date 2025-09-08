# Cert Authority in Docker

## Notes

- This repo is an attempt at a Docker implementation of this excellent article https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-on-ubuntu-22-04
- You may need to run the commands below out of order.
- Seemingly easy-rsa is a wrapper around openssl, from OpenVPN.
- PKI is an abbreviation for Public Key Infrastructure.

## Getting started

```bash
docker build -t ca_service .
docker run --name ca_service --rm -v ${PWD}/sign-requests:/tmp/ca-service/sign-requests -it ca_service bash
```

## (Re)create the working dir

Only if required i.e. starting over

```bash
rm -rf /tmp/ca-service/easy-rsa/* && ln -s /usr/share/easy-rsa/* /tmp/ca-service/easy-rsa/
```

## Initialise the PKI

```bash
cd easy-rsa
./easyrsa init-pki
```

## Create the CA

Before you can create a CA’s private key and cert, you need a `vars` file

```bash
cp /tmp/ca-service/vars /tmp/ca-service/easy-rsa/
yes | ./easyrsa build-ca nopass
```

## Verify contents of a CSR

Note the CN for use in later steps

```bash
openssl req -in sammy-server.req -noout -subject
```

## Import request

Import the request to easyrsa

```bash
./easyrsa import-req ../sign-requests/foo.csr short_name_not_the_cn
```

## Sign a request

Use the `server` request type followed by the CN that was included in the CSR

```bash
./easyrsa sign-req server cn_from_csr
```

## Copy out

```bash
rm -rf ~/Desktop/ca_service_issued
docker cp ca_service:/tmp/ca-service/easy-rsa/pki/issued ~/Desktop/ca_service_issued
```
