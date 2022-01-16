#!/usr/bin/python
# -*- coding:utf-8 -*-

from db import DB, INSERT


class Lamp(object):
    id = None
    ip = None
    state = None

    def __init__(self, id, ip, state):
        self.id = id
        self.ip = ip
        self.state = state

    def values(self):
        return (self.id, self.ip, self.state)


def discover(database: DB, url):
    from yeelight import discover_bulbs

    bulbs = discover_bulbs(interface='wlan0')

    lamps = []
    for bulb in bulbs:
        lamps.append(Lamp(bulb['capabilities']['id'], bulb['ip'], False))

    database.insert(INSERT.LAMP.value, lamps)


def all(database: DB):
    rows = database.select('lamps')

    lamps = []

    for row in rows:
        lamps.append(Lamp(row[0], row[1], row[2]))

    return lamps


def bulkInsert(database, data):
    lamps = []
    for item in data:
        print(item)
        lamps.append(Lamp(item['id'], item['ip'], item['state']))

    database.insert(INSERT.LAMP.value, lamps)
