#!/bin/bash
#
# Boot cluster
#

set -e

helm install --name=mariadb local/mariadb --namespace=openstack
helm install --name=memcached local/memcached --namespace=openstack
helm install --name=etcd-rabbitmq local/etcd --namespace=openstack
helm install --name=rabbitmq local/rabbitmq --namespace=openstack
helm install --name=ingress local/ingress --namespace=openstack
