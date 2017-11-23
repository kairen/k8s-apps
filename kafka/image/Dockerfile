FROM openjdk:8-jre-alpine

ENV KAFKA_USER=kafka \
    KAFKA_DATA_DIR=/var/lib/kafka/data \
    KAFKA_HOME=/opt/kafka \
    PATH=$PATH:/opt/kafka/bin

RUN set -ex; \
    adduser -D "$KAFKA_USER"; \
    mkdir -p "$KAFKA_DATA_DIR" "$KAFKA_HOME"; \
    chown "$KAFKA_USER:$KAFKA_USER" "$KAFKA_DATA_DIR" "$KAFKA_HOME"

ARG KAFKA_VERSION=1.0.0
ARG KAFKA_DIST=kafka_2.11-1.0.0

RUN set -ex; \
  apk add --no-cache wget gpgme bash && \
  wget -q "http://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz" && \
  wget -q "http://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz.asc" && \
  wget -q "http://kafka.apache.org/KEYS" && \
  export GNUPGHOME="$(mktemp -d)" && \
  gpg --import KEYS && \
  gpg --batch --verify "$KAFKA_DIST.tgz.asc" "$KAFKA_DIST.tgz" && \
  tar -xzf ${KAFKA_DIST}.tgz -C ${KAFKA_HOME} --strip-components=1  && \
  rm -r "$KAFKA_DIST.tgz" "$KAFKA_DIST.tgz.asc" && \
  rm -rf /var/cache/apk/*

WORKDIR $KAFKA_HOME
USER $KAFKA_USER:$KAFKA_USER

COPY ./config/ $KAFKA_HOME/config/
COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint
COPY ./scripts/healthcheck.sh /usr/local/bin/healthcheck

EXPOSE 9092

ENTRYPOINT ["entrypoint"]
