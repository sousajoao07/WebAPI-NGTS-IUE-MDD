#!/usr/bin/python
# -*- coding:utf-8 -*-

from gesture import bulkInsert as bulkInsertGestures
from lamp import bulkInsert as bulkInsertLamps
from multiprocessing import Process
from sensor import PAJ7620U2
from api import sync
from db import DB

API_ENDPOINT = "http://192.168.1.68:8080/api"
DATABASE = None
SENSOR = None


def sensorCheck():
    from time import sleep
    from lamp import discover

    try:
        print("\nGesture Sensor\n")
        discover(DATABASE)
        while True:
            sleep(0.05)
            SENSOR.check_gesture()
    except KeyboardInterrupt:
        pass


def SSEClient(table, bulkInsert):
    from sseclient import SSEClient
    from json import loads

    try:
        print("\nSync Table: " + table + "\n")

        response = sync(API_ENDPOINT, table)
        client = SSEClient(response)
        for event in client.events():
            data = loads(event.data)
            if data:
                bulkInsert(DATABASE, data)
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    try:
        DATABASE = DB()
        SENSOR = PAJ7620U2(database=DATABASE)
        p1 = Process(target=sensorCheck)
        p1.start()
        p2 = Process(target=SSEClient, args=('lamps', bulkInsertLamps,))
        p2.start()
        p3 = Process(target=SSEClient, args=('gestures', bulkInsertGestures,))
        p3.start()
        p1.join()
        p2.join()
        p3.join()
    except KeyboardInterrupt:
        print()
        pass
