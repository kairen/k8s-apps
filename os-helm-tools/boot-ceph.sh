#!/bin/bash
#
# Boot cluster
#

set -e

helm install --namespace=ceph local/ceph --name=ceph \
  --set manifests_enabled.client_secrets=false \
  --set network.public=$osd_public_network \
  --set network.cluster=$osd_cluster_network \
  --set bootstrap.enabled=true

helm install --namespace=openstack local/ceph --name=ceph-openstack-config \
  --set manifests_enabled.storage_secrets=false \
  --set manifests_enabled.deployment=false \
  --set ceph.namespace=ceph \
  --set network.public=$osd_public_network \
  --set network.cluster=$osd_cluster_network
