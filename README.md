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

Thus all Rive script entries should start with

\+ _ [*]

Where the first _ is the users name and the [*] is there as old accounts will have a last name and new ones will not.


## Docker

The docker container will take the environment variable of "MQTT_SERVER" to set the MQTT server that it communicates to
/usr/src/app/brain contains the Rive script files and should be copied to an accessible storage location so you can edit them.

The DBD::DBI and DBD:Pg modules are installed for Postresql access. For future expansion.

## Running as a docker container

you will need to edit the Makefile and set the REGISTRY variable to your registry. After which you can use make to build and push a docker container for the bot-ai.
I have provided an example Docker-Stack.yaml file that brings up the bot, bot-ai, and mosquitto-mqtt server. You will have to edit it to match your environment and replace \<botname\> with the name of your bot. 

## Running stand alone

NOTE: This has only been run and tested on Linux!

If you want to run this on your desktop or a non-docker system, you will need to install the perl libs for "Net::MQTT::Simple" and "RiveScript", you will also need to edit the bot-ai.pl file and change the line...

my $MQTT=$ENV{'MQTT_SERVER'} || "mqtt";

change the end of the line where is says "mqtt" to the name or IP of your mqtt server. In lue of that you can set and export the environment variable MQTT_SERVER to your mqtt server name or ip.


### Editing the brain

The brain is stored in the /brain directory and is a set of RiveScripts. See www.RiveScript.com for information on the scripting language. 

To start you will need to set the variables in about-bot.rive to the information for your bot.

RiveScript can be extended with objects which can be in perl, Java, or python. The objects directory contains several  examples of perl objects I have written.

The brain provided is rather simple and is a base to start building your own personalized brain from. It is missing a lot and I myself am still working on expanding it.

The personality directory contains personalities I have avaliable.  

