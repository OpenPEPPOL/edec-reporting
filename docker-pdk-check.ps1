$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
Write-Output $ScriptDir
docker run --rm -it -v --pull=always ${ScriptDir}:/src public.ecr.aws/openpeppol/pdk:latest /bin/bash