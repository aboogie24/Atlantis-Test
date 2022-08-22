#!/bin/env bash

NOW=$(date '+%Y%m%d%H%M%S')

docker images

AWS_ACCOUNT_ID=${1}

echo "${AWS_ACCOUNT_ID}"

if (
  set -x -o nounset
  aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" | \
  docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}".dkr.ecr."${AWS_DEFAULT_REGION}".amazon.com
); then

sha=$(git rev-parse HEAD)
#repository="atlantis-repo"
tag="${sha}-${NOW}"

echo "ATLANTIS_IMAGE_TAG=${tag}" >> "${GITHUB_ENV}"

fi
