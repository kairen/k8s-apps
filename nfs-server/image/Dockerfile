FROM alpine:edge

ENV EXPORT=/etc/exports

RUN set -ex; \
  apk add --no-cache nfs-utils && \
  rm -rf /var/cache/apk/*

VOLUME /exports
EXPOSE 2049/tcp 20048/tcp 111/tcp 111/udp

COPY entrypoint.sh /bin/start-nfs
ENTRYPOINT ["/bin/start-nfs"]
