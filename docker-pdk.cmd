@echo off
docker run --rm -i -v %CD%:/src public.ecr.aws/openpeppol/pdk:0.7.1 pdk %*
