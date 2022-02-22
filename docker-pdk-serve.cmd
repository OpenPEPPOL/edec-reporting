@echo off
docker run --pull --rm -i -d --name pdk-serve -v %CD%:/src -p8000:8000 public.ecr.aws/openpeppol/pdk:latest pdk serve
