FROM java:openjdk-8-jdk

ENV hadoop_ver 2.7.5
ENV spark_ver 2.2.0

RUN mkdir -p /opt && \
    cd /opt && \
    curl http://www.us.apache.org/dist/hadoop/common/hadoop-${hadoop_ver}/hadoop-${hadoop_ver}.tar.gz | \
        tar -zx hadoop-${hadoop_ver}/lib/native && \
    ln -s hadoop-${hadoop_ver} hadoop && \
    echo Hadoop ${hadoop_ver} native libraries installed in /opt/hadoop/lib/native

RUN mkdir -p /opt && \
    cd /opt && \
    curl http://www.us.apache.org/dist/spark/spark-${spark_ver}/spark-${spark_ver}-bin-hadoop2.7.tgz | \
        tar -zx && \
    ln -s spark-${spark_ver}-bin-hadoop2.7 spark && \
    echo Spark ${spark_ver} installed in /opt

RUN apt-get update && \
    apt-get install -y python-numpy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD log4j.properties /opt/spark/conf/log4j.properties
ADD start-worker start-master /
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf
ENV PATH $PATH:/opt/spark/bin
