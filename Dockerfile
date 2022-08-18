FROM ghcr.io/runatlantis/atlantis:v0.19.7
LABEL version=${VERSION}
LABEL name=${NAME}


# RUN apt-get update \
#     apt-get upgrade \
#     apt-get install python3.6 

COPY ./docker-entrypoint.sh . 
    
CMD [ "bash", "docker-entrypoint.sh" ]

EXPOSE 4241 