#!/bin/bash
#
# Boot cluster
#

set -e

# install keystone
helm install --namespace=openstack --name=keystone local/keystone \
--set pod.replicas.api=1

# install horizon
helm install --namespace=openstack --name=horizon local/horizon \
--set network.enable_node_port=true

# install glance
helm install --namespace=openstack --name=glance local/glance \
--set pod.replicas.api=1 \
--set pod.replicas.registry=1

# install neutron
helm install --namespace=openstack --name=neutron local/neutron \
--set pod.replicas.server=1

# install nova
helm install --namespace=openstack --name=nova local/nova \
--set pod.replicas.api_metadata=1 \
--set pod.replicas.osapi=1 \
--set pod.replicas.conductor=1 \
--set pod.replicas.consoleauth=1 \
--set pod.replicas.scheduler=1 \
--set pod.replicas.novncproxy=1

# install cinder
helm install --namespace=openstack --name=cinder local/cinder \
  --set pod.replicas.api=1
