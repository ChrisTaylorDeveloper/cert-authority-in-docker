#!/bin/bash

docker build -t cert_auth_srv .
docker run -it cert_auth_srv /bin/bash
