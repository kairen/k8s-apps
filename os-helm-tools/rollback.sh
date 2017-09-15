#!/bin/bash
#
# Rollback horizon
#

set -ex

helm rollback horizon 1
