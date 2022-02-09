@echo off
docker run --rm -i -d --name pdk-serve -v %CD%:/src -p8000:8000 public.ecr.aws/openpeppol/pdk:0.7.1 pdk serve
