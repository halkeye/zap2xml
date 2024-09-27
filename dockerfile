FROM alpine:3
ARG BUILD_URL
ARG DIGEST
ARG GIT_COMMIT
ARG TIMESTAMP
ARG URL
ARG VENDOR
ARG VERSION

LABEL com.github.actions.url="${BUILD_URL}"
LABEL org.opencontainers.image.created="${TIMESTAMP}"
LABEL org.opencontainers.image.base.digest="${DIGEST}"
LABEL org.opencontainers.image.base.name="docker.io/library/alpine:3"
LABEL org.opencontainers.image.description="Contains the zap2xml Perl script, a command-line utility that extracts electronic program guide (EPG) data for over-the-air (OTA) or cable television from any one of several service providers, parses it, collates it, and saves it in a format compatible with various media center applications."
LABEL org.opencontainers.image.documentation="${URL}"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.source="${URL}"
LABEL org.opencontainers.image.title="zap2xml"
LABEL org.opencontainers.image.url="${URL}"
LABEL org.opencontainers.image.vendor="${VENDOR}"
LABEL org.opencontainers.image.version="${VERSION}"

ENV USERNAME=none
ENV PASSWORD=none
ENV XMLTV_FILENAME=xmltv.xml
ENV OPT_ARGS=
# wait 12 Hours after run
ENV SLEEPTIME=43200

RUN echo '@edge https://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
  apk add --no-cache \
  ca-certificates \
  perl \
  perl-html-parser \
  perl-http-cookies \
  perl-io-socket-ssl \
  perl-json \
  perl-json-xs \
  perl-libwww \
  perl-lwp-protocol-https \
  perl-lwp-useragent-determined \
  perl-mozilla-ca \
  perl-net-http \
  perl-net-libidn \
  perl-net-ssleay \
  perl-uri \
  xmltv@edge

VOLUME /data
ADD zap2xml.pl entry.sh /
CMD /entry.sh
