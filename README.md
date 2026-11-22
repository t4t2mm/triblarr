# triblarr
Tribler container builder to improve compatibility with Servarr.

## Docker files
Dockerfile and docker-compose.yml are based upon tribler official ones : https://github.com/Tribler/tribler/tree/main/build/docker .

entrypoint.sh aims :
- To provide more flexibility in enabling the modification of the user and the inner download location.
- To give access to the Web UI when the container is running on a server.

## Folder structure
The default folder configuration is based on trash guide recommendation : https://trash-guides.info/File-and-Folder-Structure/ .

You can adapt using the environment variables in the docker-compose.yml.

## User
Use the same user as your Servarr containers and set the associated UID and GID in the docker-compose.yml.

## Web UI
Modify the passwords for each Tribler instance in the docker-compose.yml

## Build your image
Copy the files in a folder on your host.
Set this folder as you working directory and run :
~~~
docker compose build --no-cache
~~~

## Launch the container
Run :
~~~
docker compose up -d
~~~

## Launch the Web UI
Tribler-radarr
~~~
host:8085/ui/#/downloads/all?key=ChangeMeForTriblerRadarr
~~~

Tribler-sonarr
~~~
host:8086/ui/#/downloads/all?key=ChangeMeForTriblerSonarr
~~~
