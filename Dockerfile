# syntax=docker/dockerfile:1

FROM openjdk:8u312-jre-buster

LABEL version="Pre-Release-21.3"
LABEL homepage.group=Minecraft
LABEL homepage.name="The Decursio Project Expert-Pre-Release 21.3"
LABEL homepage.icon="https://media.forgecdn.net/avatars/553/92/637893326243672364.png"
LABEL homepage.widget.type=minecraft
LABEL homepage.widget.url=udp://The-Decursio-Project:25565
RUN apt-get update && apt-get install -y curl unzip && \
 adduser --uid 99 --gid 100 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/launch.sh"]

ENV MOTD " Server Powered by Docker"
ENV LEVEL world
ENV JVM_OPTS "-Xms4096m -Xmx8192m"