# Cert Authority in Docker

## Notes

- This repo is an attempt at a Docker implementation of this excellent article https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-on-ubuntu-22-04
- You may need to run the commands below out of order.
- Seemingly easy-rsa is a wrapper around openssl, from OpenVPN.

## Certificate Signing Requests

Place your certificate signing requests in directory `sign-requests`. Run the following command to inspect the subject of a certificate signing request

```bash
openssl req -in example.req -noout -subject
```

## Docker build, run

```bash
docker build -t ca_service .

# Start a container, mounting you CSRs as a shared volume
docker run --name ca_service --rm -v ${PWD}/sign-requests:/tmp/ca-service/sign-requests -it ca_service bash
```

## (Re)create working dir

Only if required i.e. if starting over

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

Before you can create a CA’s private key and cert, you need a `vars` file

```bash
# An example vars file can also be found in directory `easy-rsa`.
cp /tmp/ca-service/vars /tmp/ca-service/easy-rsa/

# With no passphrase and no interaction.
yes | ./easyrsa build-ca nopass
```


## Import request

Import a request to easyrsa. Choose a handy shortname which does not need to match the CN

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
rm -rf ~/Desktop/ca_service && mkdir -p ~/Desktop/ca_service

# Get the CA signed certs
docker cp ca_service:/tmp/ca-service/easy-rsa/pki/issued ~/Desktop/ca_service/issued

# Get the Certificate Authority certificate
docker cp ca_service:/tmp/ca-service/easy-rsa/pki/ca.crt ~/Desktop/ca_service
```

## Add to Chrome

Try chrome://certificate-manager/localcerts/usercerts and add your CA cert as a trusted certificate.
