#!/bin/bash
#
# Kafka health check script.

/opt/kafka/bin/kafka-broker-api-versions.sh --bootstrap-server=localhost:9092
