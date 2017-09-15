#!/bin/bash
#
# Serve helm repo
#

set -e

helm serve &
helm repo add local http://localhost:8879/charts
make
