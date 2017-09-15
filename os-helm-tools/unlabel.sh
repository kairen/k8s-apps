#!/bin/bash
#
# Unlabel nodes.  
#

kubectl label nodes openstack-control-plane- --all
kubectl label nodes ceph-mon- --all
kubectl label nodes ceph-osd- --all
kubectl label nodes ceph-mds- --all
kubectl label nodes openvswitch- --all
kubectl label nodes openstack-compute-node- --all
