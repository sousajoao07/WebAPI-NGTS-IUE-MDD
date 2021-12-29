#!/usr/bin/python
# -*- coding:utf-8 -*-

def createOrUpdateLamp(url, lamp):
    from requests import post
    response = post(url + '/lamp',
                    data={'id': lamp['id'], 'ip': lamp['ip']})
    print(response.status_code)


def sync(url, table):
    from requests import get
    headers = {'Accept': 'text/event-stream'}
    return get(url + '/sync/' + table, stream=True, headers=headers)
