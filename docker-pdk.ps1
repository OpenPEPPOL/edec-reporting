$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
Write-Output $ScriptDir
docker run --rm -i -v ${ScriptDir}:/src public.ecr.aws/openpeppol/pdk:0.7.2 pdk $args
#docker run --rm -it -v ${ScriptDir}:/src public.ecr.aws/openpeppol/pdk:0.7.2 /bin/bash