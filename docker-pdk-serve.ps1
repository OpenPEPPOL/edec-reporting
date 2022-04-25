$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
docker run --rm -i -d --name pdk-serve --pull=always -v ${ScriptDir}:/src -p8000:8000 public.ecr.aws/openpeppol/pdk:latest pdk serve