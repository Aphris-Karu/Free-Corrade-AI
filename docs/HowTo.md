# The Free Corrade AI How To

To start you will need a Linux host with docker installed.

When setting up the AI you will need docker set up in swarm mode. This can be done with the command

`docker swarm init`

Next you will need a configured corrade container. 

Follow Steps 1-7 at https://cloud.docker.com/repository/docker/aphris/corrade-continuous

Now that you have the configs in a directory and know the location. You can create your docker-compose.yml

We will be setting up 3 services. (corrade/mtqq/corrade-ai) you will need a location with a config for the mqtt server and a folder location for the brain used by the corrade-ai.

```
version: "3"
services:
  corrade:
    image: aphris/corrade-continuous:latest
    ports:
     - "80:54377"
    volumes:
     - (Put the full path to)/Configuration.xml:/corrade/Configuration.xml
     - (Put the full path to)/Nucleus.config:/corrade/Nucleus.config
  mqtt:
    image: eclipse-mosquitto
    volumes:
      - (Put the full path to)/mosquitto.conf:/mosquitto/config/mosquitto.conf
      - mqtt-data:/mosquitto/data
corrade-ai:
    image: phris/corrade-free-ai:latest
    environment:
      MQTT_SERVER: mqtt
    volumes:
      - (Put the full path to)/brain:/usr/src/app/brain
    depends_on:
        - mqtt
```


