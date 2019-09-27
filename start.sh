#!/bin/bash
cd /usr/src/app
if [ ! -f /usr/src/app/brain/myself.rive ]; then
   unzip -j master.zip 'Free-Corrade-AI-master/brain/*' -d /usr/src/app/brain
fi
perl ./bot-ai.pl
