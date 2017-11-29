#!/bin/bash

STORM_VERSION=${STORM_VERSION:-"1.1.1"}
STORM_CONFIG_DIR=${STORM_CONFIG_DIR:-"/opt/apache-storm-${STORM_VERSION}/conf/storm.yaml"}
STORM_ZOOKEEPER=${STORM_ZOOKEEPER:-"localhost"}
NIMBUS_SEEDS=${NIMBUS_SEEDS:-$(hostname -s)}
STORM_SUPERVISOR_SLOTS_PORTS=${STORM_SUPERVISOR_SLOTS_PORTS:-"6700 6701 6702 6703"}
STORM_LOCAL_DIR=${STORM_LOCAL_DIR:-"/tmp"}
STORM_LOG_DIR=${STORM_LOG_DIR:-"/var/lib/storm/logs"}
STORM_ROLE=${STORM_ROLE:-"nimbus ui"}

# config storm.yaml
# -------------------------------------------------------------------
echo "[ storm.yaml ]"

if [[ -n ${STORM_ZOOKEEPER} ]]; then
  echo "STORM_ZOOKEEPER=${STORM_ZOOKEEPER}"
  echo "storm.zookeeper.servers:" > ${STORM_CONFIG_DIR}
  zm_list=($(echo ${STORM_ZOOKEEPER}))
  for zm in ${zm_list[@]}; do
    echo "  - \"${zm}\"" >> ${STORM_CONFIG_DIR}
  done
fi

if [[ -n ${NIMBUS_SEEDS} ]]; then
  echo "NIMBUS_SEEDS=${NIMBUS_SEEDS}"
  nb_list=($(echo ${NIMBUS_SEEDS}))
  nb_seed_str=""
  for nb in ${nb_list[@]}; do
    nb="\"${nb}\""
    if [[ "${#nb_seed_str}" -ne "0" ]]; then
      nb=", ${nb}"
    fi
    nb_seed_str="${nb_seed_str}${nb}"
  done
  echo "nimbus.seeds: [${nb_seed_str}]" >> ${STORM_CONFIG_DIR}
fi

if [[ -n ${STORM_DRPC} ]]; then
  echo "STORM_DRPC=${STORM_DRPC}"
  echo "drpc.servers:" > ${STORM_CONFIG_DIR}
  drpc_list=($(echo ${STORM_DRPC}))
  for drpc in ${drpc_list[@]}; do
    echo "  - \"${drpc}\"" >> ${STORM_CONFIG_DIR}
  done
fi

if [[ -n ${STORM_SUPERVISOR_SLOTS_PORTS} ]]; then
  echo "STORM_SUPERVISOR_SLOTS_PORTS=${STORM_SUPERVISOR_SLOTS_PORTS}"
  echo "supervisor.slots.ports:" >> ${STORM_CONFIG_DIR}
  port_list=($(echo ${STORM_SUPERVISOR_SLOTS_PORTS}))
  for port in ${port_list[@]}; do
    echo "  - ${port}" >> ${STORM_CONFIG_DIR}
  done
fi

if [[ -n ${STORM_LOCAL_DIR} ]]; then
  echo "STORM_LOCAL_DIR=${STORM_LOCAL_DIR}"
  echo "storm.local.dir: \"${STORM_LOCAL_DIR}\"" >> ${STORM_CONFIG_DIR}
fi

if [[ -n ${STORM_LOG_DIR} ]]; then
  if [[ -n ${POD_NAME} ]]; then
    STORM_LOG_DIR="/var/lib/storm/${POD_NAME}/logs"
  fi
  mkdir -p ${STORM_LOG_DIR}
  echo "STORM_LOG_DIR=${STORM_LOG_DIR}"
  echo "storm.log.dir: \"${STORM_LOG_DIR}\"" >> ${STORM_CONFIG_DIR}
fi

echo; echo "${STORM_CONFIG_DIR}"; cat ${STORM_CONFIG_DIR}; echo

# run storm roles
# -------------------------------------------------------------------
echo "[ storm role ]"
if [[ -n ${STORM_ROLE} ]]; then
  role_list=($(echo ${STORM_ROLE}))
  for role in ${role_list[@]}; do
    echo " - ${role}"
    if [ ${role} = ${role_list[${#role_list[@]}-1]} ]; then
      /opt/storm/bin/storm ${role}
    else
      /opt/storm/bin/storm ${role} &
    fi
  done
  echo
fi
