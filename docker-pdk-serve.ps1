$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
docker run --rm -i -d --name pdk-serve -v ${ScriptDir}:/src -p8000:8000 public.ecr.aws/openpeppol/pdk:0.7.2 pdk serve