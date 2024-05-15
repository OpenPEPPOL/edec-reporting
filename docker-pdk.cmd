@echo off
aws ecr get-login-password --region eu-west-1 --profile peppol-dev | docker login --username AWS --password-stdin 070318080841.dkr.ecr.eu-west-1.amazonaws.com
docker run --rm --pull=always -i -v %CD%:/src 070318080841.dkr.ecr.eu-west-1.amazonaws.com/pdk:latest pdk %*
