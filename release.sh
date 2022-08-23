#!/bin/env bash


NOW=$(date '+%Y%m%d%H%M%S')

ID=1234564325

ID2=608911059386
echo "${ID} + ${ID2}"



if (
  set -x -o nounset
  PS=$(aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" --debug)
  docker login --log-level debug --username AWS -p ${PS} "${ID2}".dkr.ecr."${AWS_DEFAULT_REGION}".amazon.com
); then

sha=$(git rev-parse HEAD)
#repository="atlantis-repo"
tag="${sha}-${NOW}"

echo "ATLANTIS_IMAGE_TAG=${tag}" >> "${GITHUB_ENV}"

else
  status=${?}
  echo "FATAL: ECR Login failed" 1>&2
  exit "${status}"
fi

