# Cert Authority in Docker

## Notes

- This repo is an attempt at a Docker implementation of this excellent article https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-on-ubuntu-22-04
- You may need to run the commands below out of order.
- Seemingly easy-rsa is a wrapper around openssl, from OpenVPN.

## Getting started

```bash
docker build -t ca_service .
docker run --name ca_service --rm -v ${PWD}/sign-requests:/tmp/ca-service/sign-requests -it ca_service bash
```

## (Re)create working dir

Only if required i.e. if starting over!

```bash
rm -rf /tmp/ca-service/easy-rsa/* && ln -s /usr/share/easy-rsa/* /tmp/ca-service/easy-rsa/
```

## Initialise PKI

Public Key Infrastructure.

```bash
cd easy-rsa
./easyrsa init-pki
```

## Create the CA

Before you can create a CA’s private key and cert, you need a `vars` file.

```bash
# An example vars file can also be found in directory easy-rsa.
cp /tmp/ca-service/vars /tmp/ca-service/easy-rsa/

# With no passphrase and no interaction.
yes | ./easyrsa build-ca nopass
```

## Inspect the CSR

Select any of the requests in the sign-requests dir.

```bash
openssl req -in example.req -noout -subject
```

## Import request

Import the request to easyrsa. Choose any handy shortname (does not need to match the CN).

```bash
./easyrsa import-req ../sign-requests/foo.csr short_name
```

## Sign a request

Use the `server` request type, followed by the short_name

```bash
./easyrsa sign-req server short_name
```

## Copy out

Keep the container running.  Then, in another terminal

```bash
# Clean up from a previous run
rm -rf ~/Desktop/ca_service_issued
```

```bash
docker cp ca_service:/tmp/ca-service/easy-rsa/pki/issued ~/Desktop/ca_service_issued && ls -la ~/Desktop/ca_service_issued/
```
