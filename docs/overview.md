# This is the new AI for Corrade 
Note: this is an early beta version that I am still working on!


It is based on Rivescript and written using the Perl RiveScript Plugin.

* /brain contains the rivescripts for the brain
* /lists contain list of data that the brain can use.
* bot-ai.pl is the main perl brain
* Makefile will create a docker file and push it to the registry of your choice
* Dockerfile is the Docker build file to build the perl container.

The bot accepts a call that is

PRIVATE=#&AGENT=\<agent uuid\>&DATA=\<message\>

PRIVATE is a variable I use to determine if the message is for private chat, local chat, group chat, or group notice. That is processing in the LSL script.

AGENT is the agent UUID of the SL AV who typed the message

MESSAGE is the message that was typed.

The bot expects the message to be in the same format as SL communications. Thus
it should be

SLFIRST SLLAST: Message

## Docker

The docker container will take the environment variable of "MQTT_SERVER" to set the MQTT server that it communicates to
/usr/src/app/brain contains the Rive script files and should be copied to an accessible storage location so you can edit them.

The DBD::DBI and DBD:Pg modules are installed for Postresql access. For future expansion.

## Running as a docker container

you will need to edit the Makefile and set the REGISTRY variable to your registry. After which you can use make to build and push a docker container for the bot-ai.
