# The Free Corrade AI How To

To start you will need a Linux host with docker installed.

When setting up the AI you will need docker set up in swarm mode. This can be done with the command

`docker swarm init`

We will be setting up 3 services. (corrade/mtqq/corrade-ai) you will need a location with a config for the mqtt server as well as a data directory and a folder location for the brain used by the corrade-ai.

The easiest way to do this is to do the following commands on linux

```
mkdir /opt/corrade
mkdir /opt/corrade/brain
mkdir /opt/corrade/mqtt-data
```

cd into the /opt/corrade then you will need a configured corrade container. 

Follow Steps 1-7 at https://cloud.docker.com/repository/docker/aphris/corrade-continuous


I have included a mosquitto.conf in the /docs or you can view it at https://github.com/Aphris-Karu/Free-Corrade-AI/blob/master/docs/mosquitto.conf 

you can put this in /opt/corrade as well

Now you can create your docker-compose.yml by copying the below into it.

```
version: "3"
services:
  corrade:
    image: aphris/corrade-continuous:latest
    ports:
     - "80:54377"
    volumes:
     - /opt/corrade/Configuration.xml:/corrade/Configuration.xml
     - /opt/corrade/Nucleus.config:/corrade/Nucleus.config
  mqtt:
    image: eclipse-mosquitto
    volumes:
      - /opt/corrade/mosquitto.conf:/mosquitto/config/mosquitto.conf
      - /opt/corrade/mqtt-data:/mosquitto/data
  corrade-ai:
    image: aphris/corrade-free-ai:latest
    environment:
      MQTT_SERVER: mqtt
    volumes:
      - /opt/corrade/brain:/usr/src/app/brain
    depends_on:
        - mqtt
```

After saving that file, you can bring up the stack of services with the following command

`docker stack deploy corrade --compose-file=docker-compose.yml`

The AI will check the /brain directory and if it is empty it will deploy the base set of rivescript files. You will want to add a personality from this repo or build a custom personality. When you are ready to load the personality you will need to restart the ai service. To do that you will need to do the following

start by listing the containers currently running

`docker container ls`

This will list all the running containers as well as there "CONTAINER ID" Find aphris/corrade-free-ai in the list and copy the "CONTAINER ID" 

To restart the service and make it reload the scripts. you will do the following command replacing <CONTAINER ID> With the ID you copied.

`docker container stop <CONTAINER ID>`

Decause we are running in a stack, docker will see the container stop and start a new copy for you.

To see a realtime output of the stacks CPU/MEM/ and NET usage you can use the command

`docker container stats`

To stop your stack you can use the command

`docker stack rm corrade`
