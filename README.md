# Reporting BIS

The repository uses the new specification build tools for generating the artifacts and the static
site of the BIS 

## Using the scripts
Using the either the [powershell](docker-pdk.ps1), [batch script](docker-pdk.cmd) in Windows or 
the [bash](docker-pdk.sh) script on Linux and MacOS we can initiate nay of the possible build tasks 

## Starting a build
The build using the following command:
`./docker-pdk`

## cleaning up
The build using the following command:
`./docker-pdk clean` 

## Starting up the server to serve the built pages
To start the local html server run the following command:
`./docker-pdk-serve`

## Stopping the server
To stop the local html server run the following command:
`docker stop pdk-serve`
