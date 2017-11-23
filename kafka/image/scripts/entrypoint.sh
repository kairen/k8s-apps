#!/bin/bash
#
# Kafka exec script

# Disable Kafka's GC logging (which logs to a file)...
# but enable equivalent GC logging to stdout
export GC_LOG_ENABLED="false"
export KAFKA_GC_LOG_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps"
export KAFKA_BROKER_ID=${HOSTNAME##*-}
# volume for saving Kafka server logs
export KAFKA_VOLUME="/var/lib/kafka"
export KAFKA_LOG_DIRS="${KAFKA_DATA_DIR}/log-${KAFKA_BROKER_ID}"

# set log level and opts
if [ -z "${KAFKA_LOG_LEVEL}" ]; then
  KAFKA_LOG_LEVEL="INFO"
fi

if [ -z "$KAFKA_LOG4J_OPTS" ]; then
  export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:${KAFKA_HOME}/config/log4j.properties -Dkafka.root.logger.level=${KAFKA_LOG_LEVEL},CONSOLE"
fi

OPTS="--override advertised.host.name=$(hostname -i)"
if [ ! -z "${KAFKA_ADVERTISED_HOST}" ]; then
  export ADVERTISED_LISTENERS="${KAFKA_ADVERTISED_PROTOCOL_NAME}://${KAFKA_ADVERTISED_HOST}:${KAFKA_ADVERTISED_PORT},${KAFKA_PROTOCOL_NAME}://:${KAFKA_PORT}"
  export LISTENERS="${KAFKA_ADVERTISED_PROTOCOL_NAME}://:${KAFKA_ADVERTISED_PORT},${KAFKA_PROTOCOL_NAME}://:${KAFKA_PORT}"
  export INTER_LISTENER_NAME="${KAFKA_PROTOCOL_NAME}"
  export KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=${KAFKA_LISTENER_SECURITY_PROTOCOL_MAP}

  OPTS="${OPTS} --override inter.broker.listener.name=${INTER_LISTENER_NAME}"
  OPTS="${OPTS} --override advertised.listeners=${ADVERTISED_LISTENERS}"
  OPTS="${OPTS} --override listener.security.protocol.map=${KAFKA_LISTENER_SECURITY_PROTOCOL_MAP}"
  OPTS="${OPTS} --override listeners=${LISTENERS}"
fi

# print infos
echo "+==== start broker ${KAFKA_BROKER_ID} ====+"
echo "Kafka log level: ${KAFKA_LOG_LEVEL}"
echo "Kafka log dir: ${KAFKA_LOG_DIRS}"
echo "Kafka log4j opts: ${KAFKA_LOG4J_OPTS}"
echo "Kafka opts: ${OPTS}"
echo "+================================+"

# starting Kafka server with final configuration
exec ${KAFKA_HOME}/bin/kafka-server-start.sh ${KAFKA_HOME}/config/server.properties \
  --override broker.id=${KAFKA_BROKER_ID} \
  --override zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT:-zookeeper:2181}  \
  --override log.dirs=${KAFKA_LOG_DIRS} \
  --override default.replication.factor=${KAFKA_DEFAULT_REPLICATION_FACTOR:-1} \
  --override offsets.topic.replication.factor=${KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR:-3} \
  --override transaction.state.log.replication.factor=${KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR:-3} \
  ${OPTS}
