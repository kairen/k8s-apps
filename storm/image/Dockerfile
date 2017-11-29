FROM ubuntu:16.04

ARG STORM_VERSION=1.1.1

RUN apt-get update && \
    apt-get install -y default-jre wget python && \
    wget -q "http://apache.stu.edu.tw/storm/apache-storm-${STORM_VERSION}/apache-storm-${STORM_VERSION}.tar.gz" && \
    tar -xzf apache-storm-${STORM_VERSION}.tar.gz -C /opt && \
    rm -rf apache-storm-${STORM_VERSION}.tar.gz && \
    ln -s /opt/apache-storm-${STORM_VERSION} /opt/storm && \
    apt-get autoremove -y wget && \
    rm -rf /var/lib/apt/lists/*

COPY run_storm.sh /opt/storm/bin/
