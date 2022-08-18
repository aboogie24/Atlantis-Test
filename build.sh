#!/usr/bin/env bash


set -x -u
docker build . -t atlantis-image
