@echo off
aws ecr get-login-password --region eu-west-1 --profile peppol-dev | docker login --username AWS --password-stdin 070318080841.dkr.ecr.eu-west-1.amazonaws.com
docker stop pdk-serve
docker run --rm --pull=always -i -d --name pdk-serve -v %CD%:/src -p8000:8000 public.ecr.aws/openpeppol/pdk:latest pdk serve
