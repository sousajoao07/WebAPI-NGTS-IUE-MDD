#!/usr/bin/python
# -*- coding:utf-8 -*-

from enum import Enum


class INSERT(Enum):
    GESTURE = "INSERT OR REPLACE INTO gestures (id, name, action) VALUES (?,?,?)"
    LAMP = "INSERT OR REPLACE INTO lamps (id, ip, state) VALUES (?,?,?)"


class DB(object):
    def __init__(self):
        from sqlite3 import connect
        self.__connection = connect("database.db")
        self.__cursor = self.__connection.cursor()

        self.__cursor.execute(
            "CREATE TABLE IF NOT EXISTS gestures (id integer, name text, action text)")
        self.__cursor.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS gestures_idx ON gestures (id)")

        self.__cursor.execute(
            "CREATE TABLE IF NOT EXISTS lamps (id text, ip text, state integer)")
        self.__cursor.execute(
            "CREATE UNIQUE INDEX IF NOT EXISTS lamps_idx ON lamps (id)")

        self.__connection.commit

    def insert(self, sql, data):
        self.__cursor.executemany(sql, self.__toIterable(data))
        self.__connection.commit()

    def select(self, table, columns='*'):
        return self.__cursor.execute('SELECT ' + columns + ' FROM ' + table).fetchall()

    def __toIterable(self, items):
        aux = []

        for item in items:
            aux.append(item.values())

        return aux
