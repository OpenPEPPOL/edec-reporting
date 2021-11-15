$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
docker run --rm -i -d --name pdk-serve -v ${ScriptDir}:/src -p8000:8000 klakegg/pdk:v0.6.0 pdk serve