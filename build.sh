#!/bin/bash 


DATE=$(date '+%Y%m%d')

TAG=${DATE}

docker build . -t atlantis-image:${TAG}