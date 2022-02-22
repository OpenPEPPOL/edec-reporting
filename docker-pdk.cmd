@echo off
docker run --pull --rm -i -v %CD%:/src public.ecr.aws/openpeppol/pdk:latest pdk %*
