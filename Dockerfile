FROM debian:10

LABEL maintainer="captnbp"

# Don't ask questions during install
ENV DEBIAN_FRONTEND noninteractive

# By default, Squid is on open proxy
ENV LDAP_ENABLE=false
# By default, Squid listen incoming users with HTTP
ENV HTTPS_PORT_ENABLE=false
# If using TLS, provide a pem file which includes the server key, cert, ca
ENV SERVER_TLS_CERT_PATH=/srv/squid/squid.pem

# Install Squid3
# hadolint ignore=DL3008
RUN apt-get update && apt-get -y --no-install-recommends install ca-certificates squid3 && rm -rf /var/lib/apt/lists/* /tmp/*

# HTTP Port
EXPOSE 3128
# HTTPS Port 
EXPOSE 8443

COPY squid-start.sh /opt/

RUN chmod +x /opt/squid-start.sh

RUN chown -R proxy:proxy /etc/squid/

USER proxy

CMD ["/opt/squid-start.sh"]
