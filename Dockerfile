FROM perl:5.20
 
RUN cpanm install Net::MQTT::Simple
RUN cpanm install RiveScript 
RUN cpanm install DBD::Pg
RUN mkdir /usr/src/app
RUN rm -fr root/.cpanm

RUN apt-get update && apt-get install -y wget unzip procps nano

WORKDIR /usr/src/app

VOLUME ["/usr/src/app/brain"]

ADD https://github.com/Aphris-Karu/Free-Corrade-AI/archive/master.zip .

COPY start.sh /usr/src/app
RUN chmod 755 /usr/src/app/start.sh

COPY bot-ai.pl /usr/src/app

CMD [ "./start.sh" ]
