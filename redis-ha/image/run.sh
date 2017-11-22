#!/bin/bash
# Docker redis entrypoint scritp.

# Launch master when `MASTER` environment variable is set
function launchmaster() {
  if [[ ! -e /redis-data ]]; then
    echo "Redis master data doesn't exist, data won't be persistent!"
    mkdir /redis-data
  fi
  redis-server /redis-master/redis.conf --protected-mode no
}

# Launch master when `SENTINEL` environment variable is set
function launchsentinel() {
  while true; do
    master=$(redis-cli -h ${REDIS_SENTINEL_SERVICE_HOST} -p ${REDIS_SENTINEL_SERVICE_PORT} --csv SENTINEL get-master-addr-by-name mymaster | tr ',' ' ' | cut -d' ' -f1)
    if [[ -n ${master} ]]; then
      master="${master//\"}"
    else
      master=$(hostname -i)
    fi

    redis-cli -h ${master} INFO
    if [[ "$?" == "0" ]]; then
      break
    fi
    echo "Connecting to master failed.  Waiting..."
    sleep 10
  done

  sentinel_conf=sentinel.conf

  echo "sentinel monitor mymaster ${master} 6379 2" > ${sentinel_conf}
  echo "sentinel down-after-milliseconds mymaster 60000" >> ${sentinel_conf}
  echo "sentinel failover-timeout mymaster 180000" >> ${sentinel_conf}
  echo "sentinel parallel-syncs mymaster 1" >> ${sentinel_conf}
  echo "bind 0.0.0.0"

  redis-sentinel ${sentinel_conf} --protected-mode no
}

# Launch master when `SLAVE` environment variable is set
function launchslave() {
  while true; do
    master=$(redis-cli -h ${REDIS_SENTINEL_SERVICE_HOST} -p ${REDIS_SENTINEL_SERVICE_PORT} --csv SENTINEL get-master-addr-by-name mymaster | tr ',' ' ' | cut -d' ' -f1)
    if [[ -n ${master} ]]; then
      master="${master//\"}"
    else
      echo "Failed to find master."
      sleep 60
      exit 1
    fi
    redis-cli -h ${master} INFO
    if [[ "$?" == "0" ]]; then
      break
    fi
    echo "Connecting to master failed.  Waiting..."
    sleep 10
  done
  sed -i "s/%master-ip%/${master}/" /redis-slave/redis.conf
  sed -i "s/%master-port%/6379/" /redis-slave/redis.conf
  redis-server /redis-slave/redis.conf --protected-mode no
}


# Check if MASTER environment variable is set
if [[ "${MASTER}" == "true" ]]; then
  launchmaster
  exit 0
fi
# Check if SENTINEL environment variable is set
if [[ "${SENTINEL}" == "true" ]]; then
  launchsentinel
  exit 0
fi
# Launch slave if nothing is set
launchslave
