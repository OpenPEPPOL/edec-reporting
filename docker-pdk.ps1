$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
docker run --rm -i -v ${ScriptDir}:/src public.ecr.aws/openpeppol/pdk:0.7.1 pdk $args