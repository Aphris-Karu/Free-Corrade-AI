# The Free Corrade AI How To

To start you will need a Linux host with docker installed.

When setting up the AI you will need docker set up in swarm mode. This can be done with the command

`docker swarm init`

Next you will need a configured corrade container. 

Follow Steps 1-7 at https://cloud.docker.com/repository/docker/aphris/corrade-continuous

Now that you have the configs in a directory and know the location. 

We will be setting up 3 services. (corrade/mtqq/corrade-ai) you will need a location with a config for the mqtt server as well as a data directory and a folder location for the brain used by the corrade-ai.

The easiest way to do this is to do the following commands on linux

```
mkdir /opt/corrade
mkdir /opt/corrade/brain
mkdir /opt/corrade/mqtt-data
```

Now you can create your docker-compose.yml

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


