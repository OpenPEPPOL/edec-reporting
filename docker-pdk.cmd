@echo off
docker run --rm --pull=always -i -v %CD%:/src public.ecr.aws/openpeppol/pdk:latest pdk %*
