@echo off
docker run --rm --pull=always -i -d --name pdk-serve -v %CD%:/src -p8000:8000 public.ecr.aws/openpeppol/pdk:latest pdk serve
