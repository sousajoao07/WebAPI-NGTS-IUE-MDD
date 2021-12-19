#!/usr/bin/python
# -*- coding:utf-8 -*-

from yeelight import discover_bulbs as __discover_bulbs

from db import DB, INSERT


class Lamp(object):
    id = None
    ip = None

    def __init__(self, id, ip):
        self.id = id
        self.ip = ip

    def values(self):
        return (self.id, self.ip,)


def discover(database: DB):

    bulbs = __discover_bulbs()

    lamps = []
    for bulb in bulbs:
        lamps.append(Lamp(bulb['capabilities']['id'], bulb['ip']))

    database.insert(INSERT.LAMP.value, lamps)


def all(database: DB):
    rows = database.select('lamps')

    lamps = []

    for row in rows:
        lamps.append(Lamp(row[0], row[1]))

    return lamps


def bulkInsert(database, data):
    lamps = []
    for item in data:
        lamps.append(Lamp(item['ip'], item['id']))

    database.insert(INSERT.LAMP.value, lamps)
