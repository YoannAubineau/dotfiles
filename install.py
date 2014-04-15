#!/usr/bin/env python

from __future__ import absolute_import, division, print_function, unicode_literals

import datetime
import os


def main():
    timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    configdir = os.path.abspath(os.path.dirname(__file__))
    homedir = os.path.expanduser('~')
    for line in open(os.path.join(configdir, 'MANIFEST')):
        filename = line.strip()
        source = os.path.join(homedir, filename)
        target = os.path.join(os.path.basename(configdir), filename)
        if os.path.islink(source):
            os.unlink(source)
        if os.path.exists(source):
            os.rename(source, '%s.%s' % (source, timestamp))
        print('{0} -> {1}'.format(source, target))
        os.symlink(target, source)


if __name__ == '__main__':
    main()

