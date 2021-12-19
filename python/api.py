#!/usr/bin/python
# -*- coding:utf-8 -*-

API_URL = "192.168.1.68"


def getLampsIps(self):
    from requests import get
    from json import loads

    self.response = get('http://' + API_URL + ':8080/api/lamps')
    print(self.response.status_code)
    if self.response.status_code == 200:
        self.responseJson = loads(self.response.text)
        self.lamps = self.responseJson['data']
        for self.lamp in self.lamps:
            self.ip = self.lamp['ip']
            if self.ip is not None:
                return [self.lamp['ip'], self.lamp['name'], self.lamp['id']]


def createOrUpdateLamp(url, lamp):
    from requests import post
    response = post(url + '/api/lamp',
                    data={'id': lamp['id'], 'ip': lamp['ip']})
    print(response.status_code)


def sync(url, table):
    from requests import get
    headers = {'Accept': 'text/event-stream'}
    return get(url + '/sync/' + table, stream=True, headers=headers)
