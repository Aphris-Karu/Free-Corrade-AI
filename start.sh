#!/bin/sh
cd /usr/src/app
if [ ! -f /usr/src/app/brain/myself.rive ]; then
   wget https://github.com/Aphris-Karu/Free-Corrade-AI/archive/master.zip
   unzip -j master.zip 'Free-Corrade-AI-master/brain/*' -d /usr/src/app/brain
fi
./bot-ai.pl
