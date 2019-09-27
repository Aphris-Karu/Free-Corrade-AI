# This is the new AI for Corrade 
Note: this is an early beta version that I am still working on!


It is based on Rivescript and written using the Perl RiveScript Plugin.

* /brain contains the rivescripts for the brain
* /docs Contains documents on how to set up and run the AI
* /example Contains an example LSL script that you can use to connect your CORRADE bot to the AI.
* /lists contain list of data that the brain can use.
* /objects Containes rivescript objects you can add to your AI to expand it's abilities.
* /personalities Containes rivescript personalities you can add to your AI.
* /screenshot Contains a screen shot of my monitoring that shows memory, cpu, and network usage of the bot and AI.
* /test-ai Contains a perl scripts that you can run in a terminal to test and debug your rivescript brain.

* bot-ai.pl is the main perl brain
* Makefile will create a docker file and push it to the registry of your choice
* Dockerfile is the Docker build file to build the perl container.

