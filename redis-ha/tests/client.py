# -*- encoding=utf-8 -*-

import os
import redis

from redis.sentinel import Sentinel

redis_host = os.environ['REDIS_SENTINEL_SERVICE_HOST']
redis_port = os.environ['REDIS_SENTINEL_SERVICE_PORT']

sentinel = Sentinel([(redis_host, int(redis_port))], socket_timeout=1)
print("Get masters: {})".format(sentinel.discover_master('mymaster')))
print("Get slaves: {}".format(sentinel.discover_slaves('mymaster')))

master = sentinel.master_for('mymaster', socket_timeout=1)
master.set('foo', 'bar')

slave = sentinel.slave_for('mymaster', socket_timeout=1)
print("Get from slave: {}".format(slave.get('foo')))
print("Get from master: {}".format(master.get('chenjian')))
