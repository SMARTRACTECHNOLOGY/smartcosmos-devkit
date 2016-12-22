#!/usr/bin/env python
# -*- coding: latin-1 -*-

import httplib
import subprocess
import time

RED = '\033[0;31m'
GREEN = '\033[0;32m'
ORANGE = '\033[0;33m'
DEFAULT_COLOR = '\033[0m'

def err(message):
    print(RED + '✗ ' + DEFAULT_COLOR + message)

def http_get_succeeds(host, path = '/'):
    max_attempts = 10
    delay = 2

    attempts = 0
    success = False
    status = None

    while success == False and attempts < max_attempts:
        try:
            connection = httplib.HTTPConnection(host)
            connection.request('GET', path)
            status = connection.getresponse().status
            if status != None:
                success = True
        except StandardError and httplib.BadStatusLine:
            success = False
            time.sleep(attempts * delay)
        attempts += 1

    if attempts == max_attempts and success == False:
        return False
    else:
        return True

def get_up_container_data():
    ps = subprocess.Popen(('docker', 'ps', '--no-trunc'), stdout=subprocess.PIPE)
    lines = ps.communicate()[0].split('\n')
    del lines[0]
    try:
        lines.remove('')
    except ValueError:
        pass
    for line in lines:
        if 'UP' not in line:
            lines.remove(line)
    return lines

def is_in_data(name, data):
    for entry in data:
        if name in entry:
            print(name + ' is in entry')
            return True
    return False

def containers_are_up(names):
    print(names)
    container_data = get_up_container_data()
    print(container_data)
    for name in names:
        if not is_in_data(name, container_data):
            print(name + ' is not in data')
            return False
    return True

def prerequisites():
    print('\n' + ORANGE + '→ Starting database and message queue services...' + DEFAULT_COLOR)
    try:
        subprocess.check_output('docker-compose up -d mysql zookeeper kafka', shell = True)
    except subprocess.CalledProcessError:
        return None

def configserver():
    print('\n' + ORANGE + '→ Starting config-server...' + DEFAULT_COLOR)
    try:
        subprocess.check_output('docker-compose up -d config-server', shell = True)
    except subprocess.CalledProcessError:
        return None
    print("Waiting for the server to become available...")

    if http_get_succeeds('localhost:8888', '/admin/status'):
        print(GREEN + '✓' + DEFAULT_COLOR + ' Done.')
    else:
        err('The config server did not respond. It may become available later, please check the log:\n$ docker-compose logs -f config-server')

def services():
    print('\n' + ORANGE + '→ Starting user and auth services...' + DEFAULT_COLOR)
    try:
        subprocess.check_output('docker-compose up -d edge-user-devkit user-details-devkit auth-server', shell = True)
    except subprocess.CalledProcessError:
        return None
    if not containers_are_up(['edge-user-devkit', 'user-details-devkit', 'auth-server']):
        time.sleep(60)

    print('\n' + ORANGE + '→ Starting core services...' + DEFAULT_COLOR)
    try:
        subprocess.check_output('docker-compose up -d ext-relationships ext-metadata ext-things edge-things', shell = True)
    except subprocess.CalledProcessError:
        return None
    if not containers_are_up(['ext-relationships', 'ext-metadata', 'ext-things', 'edge-things']):
        time.sleep(90)

    print('\n' + ORANGE + '→ Starting event service...' + DEFAULT_COLOR)
    try:
        subprocess.check_output('docker-compose up -d events', shell = True)
    except subprocess.CalledProcessError:
        return None
    if not containers_are_up(['events']):
        time.sleep(10)

    print('\n' + ORANGE + '→ Starting user interface...' + DEFAULT_COLOR)
    try:
        subprocess.check_output('docker-compose up -d ui', shell = True)
    except subprocess.CalledProcessError:
        return None

    print('\n' + ORANGE + '→ Starting gateway...' + DEFAULT_COLOR)
    try:
        subprocess.check_output('docker-compose up -d gateway', shell = True)
    except subprocess.CalledProcessError:
        return None

def list_services():
    print(ORANGE + '→ Services started:' + DEFAULT_COLOR)
    print('$ docker ps\n')
    try:
        subprocess.check_output('docker ps', shell = True)
    except subprocess.CalledProcessError:
        return None
    print('Note that it will take a few moments until they are available and can answer requests! 💡')

def wait_for_gateway():
    if http_get_succeeds('localhost:8080'):
        print(GREEN + 'You\'re ready to take off now! Enjoy your SMART COSMOS adventures!' + DEFAULT_COLOR + ' 🚀')
    else:
        err('The gateway did not respond. It may become available later, please check the log:\n$ docker-compose logs -f gateway')


def main():
    start = time.time()

    print(ORANGE + 'Welcome to SMART COSMOS DevKit' + DEFAULT_COLOR)

    prerequisites()
    configserver()
    services()

    end = time.time()
    diff = end - start
    print('\nStarting the ' + ORANGE + 'SMART COSMOS DevKit ' + DEFAULT_COLOR + 'took %.2f seconds.\n' % diff)

    list_services()
    wait_for_gateway()

    print('\nP.S.: Use the following command to stop all services when you\'re done:\t$ docker-compose down')

main()
