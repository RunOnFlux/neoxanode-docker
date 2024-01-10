
ARG UBUNTUVER=20.04
FROM ubuntu:${UBUNTUVER}
LABEL com.centurylinklabs.watchtower.enable="true"

ENV VERSION="5.1.1.4"
RUN mkdir -p /root/.neoxacore
RUN apt-get update && apt-get install -y  tar unzip wget curl pwgen jq
RUN wget https://github.com/NeoxaChain/Neoxa/releases/download/v${VERSION}/neoxad-${VERSION}-linux64.zip -P /tmp
RUN unzip /tmp/neoxad-${VERSION}-linux64.zip -d /tmp \
&& cp /tmp/* /usr/local/bin \
&& chmod +x /usr/local/bin/*
COPY node_initialize.sh /node_initialize.sh
COPY check-health.sh /check-health.sh
COPY key.sh /key.sh
VOLUME /root/.neoxacore
RUN chmod 755 node_initialize.sh check-health.sh key.sh
EXPOSE 8788
HEALTHCHECK --start-period=5m --interval=10m --retries=5 --timeout=25s CMD ./check-health.sh
CMD ./node_initialize.sh
