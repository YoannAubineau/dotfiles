#!/usr/bin/env bash
# Create a new Kerberos keytab or override an existing one.

if [ $# -ne 2 ]; then
    CMD=$(basename $0)
    echo "Usage: ${CMD} <kerberos_principal> <keytab_filepath>"
    exit 1
fi

KERBEROS_PRINCIPAL=$1
KEYTAB_FILEPATH=$2

PASSWORD_ENCODING="aes128-cts-hmac-sha1-96"

# Install ktutil if missing
if [ -z $(which ktutil) ]; then
    [ $(uname -o) == "GNU/Linux" ] && sudo apt-get install krb5-user
    [ $(uname -o) == "Cygwin" ] && apt-cyg install krb5-workstation
fi

# Get Kerberos password for given principal
read -s -p "Enter password for ${KERBEROS_PRINCIPAL}: " PASSWORD
echo

# Delete already existing keytab
if [ -e ${KEYTAB_FILEPATH} ]; then
    rm -f ${KEYTAB_FILEPATH}
fi

# Create new keytab
(
    set +xv  # prevent password to be echoed to the console
    {
        echo "add_entry -password -p ${KERBEROS_PRINCIPAL} -k 1 -e ${PASSWORD_ENCODING}"
        echo "${PASSWORD}"
        echo "write_kt ${KEYTAB_FILEPATH}"
    } | ktutil > /dev/null
)

echo "Kerberos keytab written to ${KEYTAB_FILEPATH}"
