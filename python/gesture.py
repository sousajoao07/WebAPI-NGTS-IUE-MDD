#!/usr/bin/python
# -*- coding:utf-8 -*-

from db import DB, INSERT


class Gesture(object):
    id = None
    name = None
    action = None

    def __init__(self, id, name, action):
        self.id = id
        self.name = name
        self.action = action

    def values(self):
        return (self.id, self.name, self.action,)


def all(database: DB):
    rows = database.select('gestures')

    gestures = []

    for row in rows:
        gestures.append(Gesture(row[0], row[1], row[2]))

    return gestures


def bulkInsert(database, data):
    gestures = []
    for item in data:
        gestures.append(Gesture(item['id'], item['name'], item['action']))
    database.insert(INSERT.GESTURE.value, gestures)
    all(database)
