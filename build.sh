#!/bin/bash


set -x -u
docker build . -t atlantis-image
