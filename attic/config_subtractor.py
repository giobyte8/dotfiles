#!/usr/bin/python3

import sys, os

_target_file = sys.argv[1]
_file = open(_target_file, 'r')
_file_name = os.path.basename(_file.name)
_lines = _file.readlines()

groups = {}
curr_group = ''
for line in _lines:
    if line.startswith('['):
        curr_group = line.strip()
        curr_group = curr_group[1:-1]
        groups[curr_group] = []
    else:
        try:
            eq_idx = line.index('=')
            if eq_idx > 0:
                groups[curr_group].append(line)
        except:
            pass

curr_group_key = ''
for group in groups:
    if group != curr_group_key:
        curr_group_key = group
        print('')

    for key_value in groups[group]:
        eq_idx = key_value.index('=')
        key = key_value[0:eq_idx]
        value = key_value[eq_idx + 1::].rstrip('\n')

        command = 'kwriteconfig5 --file %s '

        # Appends --group
        command += '--group '
        try:
            if group.index(' ') > 0:
                command += '"%s" '
        except:
            command += '%s '
        
        # Appends --key
        command += '--key '
        try:
            if key.index(' ') > 0:
                command += '"%s" '
        except:
            command += '%s '
        
        # Appends <value>
        try:
            if value.index(' ') > 0:
                command += '"%s"'
        except:
            command += '%s'            

        print(command % (_file_name, group, key, value))
