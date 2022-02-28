#!/usr/bin/env python3
#
# Dependencies:
# python-dbus installed through:
#   - sudo apt-get install python[3]-dbus

from argparse import ArgumentParser
from dbus import Interface, SessionBus, DBusException


# Setup arguments parser
parser = ArgumentParser(description='DBus controller for spotify')
parser.add_argument(
    'action', 
    nargs=1, 
    choices=['toggle', 'next', 'previous', 'title', 'status']
)
action = parser.parse_args().action[0]

try:
    bus = SessionBus()
    proxy = bus.get_object('org.mpris.MediaPlayer2.spotify', '/org/mpris/MediaPlayer2')
    player = Interface(proxy, dbus_interface='org.mpris.MediaPlayer2.Player')
    props = Interface(proxy, dbus_interface='org.freedesktop.DBus.Properties')

    if action == 'toggle':
        player.PlayPause()
    elif action == 'next':
        player.Next()
    elif action == 'previous':
        player.Previous()
    elif action == 'title':
        metadata = props.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
        title = metadata.get('xesam:title')
        width_allowed = 20

        if len(title) > width_allowed:
            short_title = title[0:width_allowed - 3]
            print(short_title + '...')
        else:
            print(title)
    elif action == 'status':
        status = props.Get(
            'org.mpris.MediaPlayer2.Player',
            'PlaybackStatus'
        )
        print(status)
except DBusException:
    print("")
