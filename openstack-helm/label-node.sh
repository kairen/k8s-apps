#!/bin/bash
#
# Label nodes
# 

set -xe

kubectl label nodes node2 openstack-control-plane=enabled
kubectl label nodes node2 openvswitch=enabled
kubectl label nodes node3 openstack-control-plane=enabled
kubectl label nodes node3 openvswitch=enabled
kubectl label nodes node3 ceph-mon=enabled
kubectl label nodes node4 ceph-mon=enabled
kubectl label nodes node5 ceph-mon=enabled
kubectl label nodes node3 ceph-osd=enabled
kubectl label nodes node4 ceph-osd=enabled
kubectl label nodes node5 ceph-osd=enabled
kubectl label nodes node3 ceph-mds=enabled
kubectl label nodes node4 ceph-mds=enabled
kubectl label nodes node5 ceph-mds=enabled
kubectl label nodes node6 openvswitch=enabled
kubectl label nodes node7 openvswitch=enabled
kubectl label nodes node8 openvswitch=enabled
kubectl label nodes node6 openstack-compute-node=enabled
kubectl label nodes node7 openstack-compute-node=enabled
kubectl label nodes node8 openstack-compute-node=enabled
