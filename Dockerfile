FROM ghcr.io/runatlantis/atlantis:v0.19.7

ARG version


RUN set -ex \
    && apk update \
    && apk upgrade --no-cache \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache python3

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# CMD [ "bash", "docker-entrypoint.sh" ]

LABEL version=${version}
LABEL name="atlantis"

EXPOSE 4141
