#!/bin/bash
#
# Add compute node
#

kubectl label nodes node5 openvswitch=enabled
kubectl label nodes node5 openstack-compute-node=enabled
