$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
Write-Host "Current script directory is $ScriptDir"

docker run --rm -i -v ${ScriptDir}:/src -p8000:8000 klakegg/pdk:v0.6.0 pdk $args