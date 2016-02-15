#!/usr/bin/env python

from __future__ import absolute_import, division, print_function, unicode_literals

import argparse
import re
import subprocess
import sys


re_blank_line = re.compile(r'''^\s*$''')
re_comment = re.compile(r'''^\s*#''')
re_affectation = re.compile(r'''^\s*(?P<key>[_a-zA-Z]\w*)=(?P<value>(?:"(?:\\"|[^"])*"|'.*?'|[^#;\n])*)''')
re_command = re.compile(r'''^\s*(?:.*?\s+){6}(?P<command>.+)$''')

parser = argparse.ArgumentParser()
parser.add_argument('filepath')
parser.add_argument('--ask', action='store_true')
args = parser.parse_args()

with open(args.filepath) as f:
    lines = [line.strip() for line in f if
        not re_blank_line.match(line) and
        not re_comment.match(line)
    ]

env = {}

for line in lines:
    m = re_affectation.match(line)
    if m:
        print('+' + line)
        key, value = m.group('key'), m.group('value')
        value = value.strip('"\'')
        env[key] = value
        continue
    m = re_command.match(line)
    if m:
        cmd = m.group('command')
        print('+' + cmd)
        if args.ask:
            while True:
                msg = 'run command? [Y/n] '
                sys.stderr.write(msg)
                if sys.version_info.major >= 3:
                    key = input()
                else:
                    key = raw_input()
                if key in ('', 'y', 'Y', 'n', 'N'):
                    break
            if key in ('n', 'N'):
                continue
        try: output = subprocess.check_output(cmd, env=env, shell=True, stderr=subprocess.STDOUT)
        except subprocess.CalledProcessError as e:
            if 'output' in locals() and output:
                print(output)
            print('returncode: {}'.format(e.returncode))
        else:
            if output:
                print(output)
        continue
    print('+' + line)
    raise Exception('can\'t parse line: ' + line)

