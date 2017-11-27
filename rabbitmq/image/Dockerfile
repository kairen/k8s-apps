FROM alpine:edge

ENV RABBITMQ_LOG_BASE=/data/log \
    RABBITMQ_MNESIA_BASE=/data/mnesia \
    RABBITMQ_HOME=/opt/rabbitmq

ARG VERSION=3.6.14

RUN apk add --update --no-cache wget tar xz bash \
  erlang erlang-mnesia \
  erlang-public-key erlang-crypto \
  erlang-ssl erlang-sasl \
  erlang-asn1 erlang-inets \
  erlang-os-mon erlang-xmerl \
  erlang-eldap erlang-syntax-tools && \
  wget "https://www.rabbitmq.com/releases/rabbitmq-server/v${VERSION}/rabbitmq-server-generic-unix-${VERSION}.tar.xz" && \
  mkdir -p ${RABBITMQ_HOME} && \
  tar --extract --verbose --file "rabbitmq-server-generic-unix-${VERSION}.tar.xz" --directory ${RABBITMQ_HOME} --strip-components 1 && \
  rm -rf "rabbitmq-server-generic-unix-${VERSION}.tar.xz" && \
  rm -rf /var/cache/apk/*

ENV PATH=$RABBITMQ_HOME/sbin:$PATH

RUN addgroup rabbitmq && \
    adduser -DS -g "" -G rabbitmq -s /bin/sh -h /var/lib/rabbitmq rabbitmq && \
    mkdir -p /data/ /etc/rabbitmq && \
    chown -R rabbitmq:rabbitmq /data/ ${RABBITMQ_HOME} && \
    rabbitmq-plugins --offline enable rabbitmq_management && \
    echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

COPY .erlang.cookie /var/lib/rabbitmq/.erlang.cookie
RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie && \
    ln -sf /var/lib/rabbitmq/.erlang.cookie /root/ && \
    chmod 400 /var/lib/rabbitmq/.erlang.cookie /root/.erlang.cookie

VOLUME ["/data"]

WORKDIR /data

COPY ./entrypoint.sh /usr/local/bin/entrypoint
EXPOSE 4369 5671 5672 15671 15672 25672

ENTRYPOINT ["entrypoint"]
CMD ["tail"]
