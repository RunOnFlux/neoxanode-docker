FROM ubuntu:22.04
LABEL com.centurylinklabs.watchtower.enable="true"

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates wget curl jq pwgen supervisor cron unzip procps \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /root/.neoxacore /var/log/supervisor

# Install Neoxa Core. The daemon-only zip contains neoxad + neoxa-cli at root.
# (The neoxaqt-* asset is the GUI — do not use it.)
ARG NEOX_VERSION=5.2.0.0
RUN set -eux; \
    wget -qO /tmp/neox.zip \
      "https://github.com/NeoxaChain/Neoxa/releases/download/v${NEOX_VERSION}/neoxad-${NEOX_VERSION}-linux64.zip"; \
    unzip -o /tmp/neox.zip neoxad neoxa-cli -d /usr/local/bin || unzip -o /tmp/neox.zip -d /usr/local/bin; \
    chmod +x /usr/local/bin/neoxad /usr/local/bin/neoxa-cli; \
    rm -f /tmp/neox.zip

COPY coin.env /usr/local/bin/coin.env
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY node_initialize.sh /usr/local/bin/node_initialize.sh
COPY mn-autoheal.sh /usr/local/bin/mn-autoheal.sh
COPY check-health.sh /usr/local/bin/check-health.sh
RUN chmod 755 /usr/local/bin/node_initialize.sh /usr/local/bin/mn-autoheal.sh \
              /usr/local/bin/check-health.sh /usr/local/bin/coin.env

VOLUME /root/.neoxacore
EXPOSE 8788
HEALTHCHECK --start-period=20m --interval=10m --retries=3 --timeout=15s CMD /usr/local/bin/check-health.sh
ENTRYPOINT ["/usr/bin/supervisord"]
