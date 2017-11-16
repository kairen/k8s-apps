#!/bin/bash
#
# Reset cluster
#

set -e

for svc in cinder nova neutron horizon glance keystone; do
  count=$(helm ls | grep nova | wc -l)
  if [ ${count} -ge 1 ]; then
    helm delete --purge ${svc}
  fi
done

for db in cinder neutron nova nova_api glance keystone horizon; do
  kubectl exec mariadb-0 -it -n openstack -- mysql -h mariadb.openstack -uroot -ppassword -e "DROP database ${db};"
done
