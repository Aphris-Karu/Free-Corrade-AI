FROM perl:5.20
 
RUN cpanm install Net::MQTT::Simple
RUN cpanm install RiveScript 
RUN cpanm install DBD::Pg
RUN mkdir /usr/src/app
RUN rm -fr root/.cpanm

WORKDIR /usr/src/app

COPY . /usr/src/app

CMD [ "perl", "./bot-ai.pl" ]
