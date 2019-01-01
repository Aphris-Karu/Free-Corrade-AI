## This is the new AI for Corrade 

It is based on Rivescript and written using the Perl RiveScript Plugin.

* /brain contains the rivescripts for the brain
* /lists contain list of data that the brain can use.
* bot-ai.pl is the main perl brain
* Makefile will creat a docker file and push it to the repo
* Dockerfile is the Docker build file to build the perl container.

The bot expects communications to be in the same format as SL communications. Thus
it sould he

SLFIRST SLLAST: Message

Thus all Rive script entries sould start with

\+ _ [*]

Where the first _ is the users name and the [*] is there as old accounts will have a last name and new ones will not.


## Docker

The docker container will take the environment variable of "MQTT_SERVER" to set the MQTT server that it communicates to
/usr/src/app/brain containe the Rive script files and should be copied to an excessable storage location so you can edit them.

The DBD::DBI and DBD:Pg modules are installed for Postresql access. For future expansion.

Environment Vars
MQTT_SERVER
DBNAME
DBSRV
DBPORT
DBUSER
DBPASSWD
