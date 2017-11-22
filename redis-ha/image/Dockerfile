FROM alpine:edge

ENV REDIS_VERSION 4.0.2-r1

RUN apk add --no-cache -U redis=${REDIS_VERSION} sed bash && \
  rm -rf /var/cache/apk/*

COPY redis-master.conf /redis-master/redis.conf
COPY redis-slave.conf /redis-slave/redis.conf
COPY run.sh /run.sh

CMD [ "/run.sh" ]

ENTRYPOINT [ "bash", "-c" ]
