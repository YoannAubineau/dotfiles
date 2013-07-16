#!/usr/bin/env bash

set -e -x

# source
S_HOSTNAME=${1}
S_USERNAME=${2}
S_DATABASE=${3}
S_SCHEMA=${4}
S_TABLE=${5}

# target
T_HOSTNAME=${6}
T_USERNAME=${7}
T_DATABASE=${8}
T_SCHEMA=${9}
T_TABLE=${10}

PG_DUMP=/usr/local/pgsql/bin/pg_dump
PSQL=/usr/local/pgsql/bin/psql

${PG_DUMP} ${S_DATABASE} -h ${S_HOSTNAME} -U ${S_USERNAME} -t ${S_SCHEMA}.${S_TABLE} | sed \
    -e "/^[^0-9]/ s/ ${S_SCHEMA}\(\W\)/ ${T_SCHEMA}\1/g" \
    -e "/^[^0-9]/ s/${S_TABLE}/${T_TABLE}/g" \
    -e "/CREATE TABLE/i DROP TABLE IF EXISTS ${T_TABLE};\n" \
    -e "/OWNER/,+2d" \
    -e "/REVOKE/d" \
    -e "/GRANT/d" \
    -e "s/, pg_catalog//" \
    -e "s/DEFAULT nextval(.*) //" \
    -e "s/ geometry/ public.geometry/" \
    | ${PSQL} ${T_DATABASE} -h ${T_HOSTNAME} -U ${T_USERNAME} -v ON_ERROR_STOP=1

