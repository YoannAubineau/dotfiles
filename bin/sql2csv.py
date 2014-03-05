#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function, unicode_literals

import sys

import pyma.argparse
import pyma.csv
import pyma.db.postgresql


args = pyma.argparse.parse_args([
    ('db', {}),
    ('--excel-compat', {'action': 'store_true'}),
])

db = pyma.db.postgresql.connect(args.db)

if args.excel_compat:
    pyma.csv.enable_excel_compat()

sql = sys.stdin.read()
db.print_csv(sql)

