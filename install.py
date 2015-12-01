#!/usr/bin/env python

from __future__ import absolute_import, division, print_function, unicode_literals

import optparse
import datetime
import os


def main():
    parser = optparse.OptionParser()
    parser.add_option('-n', '--dry-run', action='store_true')
    (options, args) = parser.parse_args()

    timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    configdir = os.path.abspath(os.path.dirname(__file__))
    homedir = os.path.expanduser('~')

    lines = open(os.path.join(configdir, 'MANIFEST'))
    for line in lines:
        chunks = line.split('#', 1)
        if len(chunks) == 1:
            filename, comment = line, ''
        else:
            filename, comment = chunks
        filename = filename.strip()

        source = os.path.join(homedir, filename)
        target = os.path.join(configdir, filename)

        print('{0} -> {1}'.format(source, target))
        if options.dry_run:
            continue

        if os.path.islink(source):
            os.unlink(source)
        if os.path.exists(source):
            os.rename(source, '%s.%s' % (source, timestamp))

        if 'HARDLINK' in comment:
            os.link(target, source)
        else:
            os.symlink(target, source)


if __name__ == '__main__':
    main()

