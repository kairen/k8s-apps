#!/bin/bash
#
# Zookeeper entrypoint script.

# Disable JMX until we need it
export ZOO_TICK_TIME=${ZOO_TICK_TIME:-"2000"}
export ZOO_INIT_LIMIT=${ZOO_INIT_LIMIT:-"5"}
export ZOO_SYNC_LIMIT=${ZOO_SYNC_LIMIT:-"2"}
export ZOO_MAX_CLIENT_CNXNS=${ZOO_MAX_CLIENT_CNXNS:-"0"}

export JMXDISABLE=true
export BASE_HOSTNAME=$(hostname | rev | cut -d "-" -f2- | rev)
export BASE_FQDN=$(hostname -f | cut -d "." -f2-)
export ZOOKEEPER_ID=$(hostname | awk -F'-' '{print $NF+1}')


# Write myid only if it doesn't exist
if [[ ! -f "${ZOO_DATA_DIR}/myid" ]]; then
    echo "Detected Zookeeper ID ${ZOOKEEPER_ID}"
    echo ${ZOOKEEPER_ID} > ${ZOO_DATA_DIR}/myid
fi

# Write the config file
cat > ${ZOO_CONF_DIR}/zk.properties <<EOF
dataDir=${ZOO_DATA_DIR}
dataLogDir=${ZOO_DATA_LOG_DIR}

timeTick=${ZOO_TICK_TIME}
initLimit=${ZOO_INIT_LIMIT}
syncLimit=${ZOO_SYNC_LIMIT}
clientPort=${ZOO_PORT}
quorumListenOnAllIPs=true
maxClientCnxns=${ZOO_MAX_CLIENT_CNXNS}

# 4lw.commands.whitelist=stat, ruok
autopurge.snapRetainCount=3
autopurge.purgeInterval=1

EOF

NODE=1
while [ $NODE -le $ZOOKEEPER_NODE_COUNT ]; do
    echo "server.${NODE}=${BASE_HOSTNAME}-$((NODE-1)).${BASE_FQDN}:2888:3888" >> ${ZOO_CONF_DIR}/zk.properties
    let NODE=NODE+1
done

echo "+= Starting Zookeeper with configuration =+"
cat ${ZOO_CONF_DIR}/zk.properties
echo "+=========================================+"

if [ -z "$ZOOKEEPER_LOG_LEVEL" ]; then
  ZOOKEEPER_LOG_LEVEL="DEBUG"
fi
if [ -z "$ZOO_LOG4J_PROP" ]; then
  export ZOO_LOG4J_PROP="$ZOOKEEPER_LOG_LEVEL,CONSOLE"
fi

# starting Zookeeper with final configuration
exec zkServer.sh start-foreground ${ZOO_CONF_DIR}/zk.properties
