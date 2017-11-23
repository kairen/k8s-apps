#!/usr/bin/env python
# coding=utf-8

import threading, logging, time
import multiprocessing

from kafka import KafkaConsumer, KafkaProducer

server = '10.99.218.122:9092'

class Producer(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.stop_event = threading.Event()

    def stop(self):
        self.stop_event.set()

    def run(self):
        producer = KafkaProducer(bootstrap_servers=server)

        i = 0
        while i <= 1:
            producer.send('my-topic', b"test")
            time.sleep(1)
            i = i + 1

        producer.close()


def main():
    Producer().run()

if __name__ == "__main__":
    logging.basicConfig(
        format='%(asctime)s.%(msecs)s:%(name)s:%(thread)d:%(levelname)s:%(process)d:%(message)s',
        level=logging.INFO
        )
    main()
