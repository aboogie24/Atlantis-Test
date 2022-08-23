#!/bin/env bash


NOW=$(date '+%Y%m%d%H%M%S')

ID=608911059386

ID2=123456432
echo "${ID} + ${ID2}"



if (
  set -x -o nounset
  aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" | docker login --username AWS --password-stdin "${ID}".dkr.ecr."${AWS_DEFAULT_REGION}".amazon.com
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

