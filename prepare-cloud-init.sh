#!/bin/bash

set -eu -o pipefail

if [[ $# -lt 3 ]]; then
  echo "usage: $(basename $0) GITHUB_REPO_URL RUNNER_TOKEN HETZNER_API_KEY [OUTPUT_FILE]"
  exit 1
fi

export GITHUB_REPO_URL=${1}
export RUNNER_TOKEN=${2}
export HETZNER_API_KEY=${3}

export PRE_JOB_SCRIPT=$(echo 'echo Hetzner runner has been started.' | base64 -w0)
docker_compose_template=$(dirname $0)/docker-compose.yml.tmpl

export DOCKER_COMPOSE_YML=$(envsubst < ${docker_compose_template} | base64 -w 0)

template_file=$(dirname $0)/cloud-init.yml.tmpl

if [[ $# == 3 ]]; then
  envsubst < "${template_file}"
else
  touch "${4}"
  envsubst < "${template_file}" > "${4}"
fi
