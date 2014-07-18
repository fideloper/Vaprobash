#!/usr/bin/env bash
#
# Checks for and creates a MySQL database.
# Author: Augusto Pascutti <augusto@phpsp.org.br>

[[ $DEBUG ]] && set -x;

USERNAME=$1
PASSWORD=$2
DATABASE_NAME=$3
SQL_FILE=$4
MYSQL_AUTH="-u${USERNAME}"

echo ">>> Creating database ${DATABASE_NAME}"

[[ -z "`which mysql`" ]] && { echo "!!! MySQL not installed."; exit 1; }
[[ ! -z "${PASSWORD}" ]] && { MYSQL_AUTH="${MYSQL_AUTH} -p${PASSWORD}"; }
[[ -z "${SQL_FILE}" ]] && { echo "!!! SQL file to be imported not informed."; exit 1; }
[[ -f "${SQL_FILE}" ]] || { echo "!!! SQL file to be imported not found. (${SQL_FILE})"; exit 1; }

HAS_DATABASE=$(mysql ${MYSQL_AUTH} -E -e "SHOW DATABASES LIKE '${DATABASE_NAME}'" | grep -v row | cut -d: -f2 | wc -l)
if [ $HAS_DATABASE -eq 0 ]; then
    mysqladmin ${MYSQL_AUTH} create ${DATABASE_NAME}
    Q1="GRANT ALL ON *.* TO '${USERNAME}'@'%' IDENTIFIED BY '${PASSWORD}' WITH GRANT OPTION;"
    Q2="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}"

    mysql ${MYSQL_AUTH} -e "${SQL}"
fi

mysql $MYSQL_AUTH -D ${DATABASE_NAME} < $SQL_FILE
