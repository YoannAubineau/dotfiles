#!/usr/bin/env bash

TABLENAME=$1

pg_dump -h sql1.meilleursagents -U meilleursagents meilleursagents -t $TABLENAME -F custom > $TABLENAME.dump
pg_restore -h localhost -U meilleursagents_dev -d meilleursagents_dev --clean --jobs=8 $TABLENAME.dump

rm $TABLENAME.dump

