#!/usr/bin/env bash
#
# MySQL/MariaDB helper script.
# Handle commom tasks such database and user creation.
#
# Author: Augusto Pascutti <augusto [at] phpsp.org.br>

function mysql_show_usage {
cat <<- _EOT_
Perform administration tasks related to MySQL/MariaDB on Ubuntu Server.
Each action have its own required/optional options, read carefully the
information below:

Usage: $0 [options] <action>

    Available actions:

        enable-remote       Enables remote connections on a MySQL/MariaDB
                            instance.
                            Requires: user (-u) and passwd (-p).

        create-database     Creates a given database and ensures the informed
                            user has access to it.
                            Requires: user (-u), passwd (-p) and database (-d).

        import-database     Imports a given SQL file to specified database, also
                            ensures that the given user has access to it.
                            Requires: user (-u), passwd (-p), database (-d) and file (-i).


    Available options:

        -u <user>           MySQL user to use on action. (Ex: root)

        -p <passwd>         MySQL password of the user being used. (Ex: root)
                            Cannot be empty by script limitations.

        -d <database>       Database name to be created or used for SQL import.

        -i <input file>     File to be imported into a given database.
                            Full path is required.

_EOT_
}

# Commands piped to this will receive 4 spaces before any output
function mysql_indent {
    sed "s/^/    /"
}

# adding grant privileges to mysql root user from everywhere
# thx to http://stackoverflow.com/questions/7528967/how-to-grant-mysql-privileges-in-a-bash-script for this
function mysql_enable_remote_connections {
    version_being_used=${1:-"5.5"}
    if [ "$version_being_used" -eq "5.6" ]; then
        sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
    else
        sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
    fi
    [[ $? -eq 0 ]] && { echo "Remote access successfully enabled."; return 0; }
    echo "An unknown error occurred while enabling remote access to MySQL"
    return 1;
}

# Grants every available GRANT TYPE on every database to given user
function mysql_grant_everything_for_user {
    USERNAME=$1
    PASSWORD=$2
    [[ -z "$USERNAME" ]] && { echo "!!! Missing username to enable MySQL/MariaDB remote access."; exit 1; }
    [[ -z "$PASSWORD" ]] && { echo "!!! Missing password to enable MySQL/MariaDB remote access."; exit 1; }

    MYSQL_AUTH="-u$USERNAME -p$PASSWORD"
    Q1="GRANT ALL ON *.* TO '$1'@'%' IDENTIFIED BY '$2' WITH GRANT OPTION;"
    Q2="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}"

    $MYSQL $MYSQL_AUTH -e "$SQL"
    [[ $? -eq 0 ]] && { echo "Granted access to user $MYSQL_USER on MySQL"; return 0; }
    echo "An unknown error occurred while granting access to user on MySQL"
    return 1
}

function mysql_ensure_database_is_created {
    DATABASE=$3
    [[ -z "$DATABASE" ]] && { echo "!!! Missing name to create MySQL/MariaDB database"; exit 1; }
    mysql_grant_everything_for_user $@

    HAS_DATABASE=$($MYSQL ${MYSQL_AUTH} -E -e "SHOW DATABASES LIKE '${DATABASE}'" | grep -v row | cut -d: -f2 | wc -l)
    if [ $HAS_DATABASE -eq 0 ]; then
        $MYSQLADMIN ${MYSQL_AUTH} create ${DATABASE}
        [[ $? -eq 0 ]] && { echo "Database ${DATABASE} created on MySQL."; return 0; }
    else
        echo "Database ${DATABASE} already exists, skipping creation."
        return 0
    fi
}

function mysql_import_database_from_file {
    DATABASE_FILE=$4

    mysql_ensure_database_is_created $@
    $MYSQL $MYSQL_AUTH -D $DATABASE < $DATABASE_FILE
    [[ $? -eq 0 ]] && { echo "SQL file imported successfully."; return 0; }
    echo "An unknown error occurred while importing SQL file to MySQL database."
    return 1;
}

# --------------------------------------------------------------------------- Script exection
MYSQL=`which mysql`
MYSQLADMIN=`which mysqladmin`
MYSQL_VERSION="5.5"

while getopts "u:p:d:i:v:h" OPTION; do
    case $OPTION in
        u)
            [[ -z "$OPTARG" ]] && { echo "!!! MySQL user cannot be empty."; exit 1; }
            MYSQL_USER=$OPTARG
            ;;
        p)
            [[ -z "$OPTARG" ]] && { echo "!!! MySQL password cannot be empty."; exit 1; }
            MYSQL_PASSWORD=$OPTARG
            ;;
        d)
            [[ -z "$OPTARG" ]] && { echo "!!! MySQL database name cannot be empty."; exit 1; }
            MYSQL_DATABASE=$OPTARG
            ;;
        i)
            [[ -z "$OPTARG" ]] && { echo "!!! File to be imported in a MYSQL database cannot be empty."; exit 1; }
            [[ -f "$OPTARG" ]] || { echo "!!! File to be imported into MySQL database needs to exist: ${OPTARG}."; exit 1; }
            MYSQL_IMPORT_FILE=$OPTARG
            ;;
        v)
            VERSION="$OPTARG"
            if [[ $VERSION -ne "5.5" && $VERSION -ne "5.6" ]]; then
                echo "!!! Acceptable versions are 5.5 or 5.6, $VERSION given."
                exit 1
            fi
            MYSQL_VERSION=$VERSION
            ;;
        h)
            mysql_show_usage
            ;;
        *)
            echo "!!! An unknown option was used OR no required value for option was passed."
            mysql_show_usage
            ;;
    esac
done

# Sets the action as the last parameter avaiable (Dirty hack)
for ACTION; do true; done
# Executes an action
case $ACTION in
    "enable-remote")
        [[ -z "$MYSQL_USER" ]] && { echo "!!! MySQL user is required by ${ACTION}."; exit 1; }
        [[ -z "$MYSQL_PASSWORD" ]] && { echo "!!! MySQL passwrd is required by ${ACTION}."; exit 1; }

        echo "Enabling remote access on MySQL" | mysql_indent
        mysql_enable_remote_connections $MYSQL_VERSION | mysql_indent
        mysql_grant_everything_for_user $MYSQL_USER $MYSQL_PASSWORD | mysql_indent
        service mysql restart | mysql_indent
        ;;
    "create-database")
        [[ -z "$MYSQL_USER" ]] && { echo "!!! MySQL user is required by ${ACTION}."; exit 1; }
        [[ -z "$MYSQL_PASSWORD" ]] && { echo "!!! MySQL passwrd is required by ${ACTION}."; exit 1; }
        [[ -z "$MYSQL_DATABASE" ]] && { echo "!!! MySQL database is required by ${ACTION}."; exit 1; }

        echo "Creating database $MYSQL_DATABASE on MySQL" | mysql_indent
        mysql_ensure_database_is_created $MYSQL_USER $MYSQL_PASSWORD $MYSQL_DATABASE | mysql_indent
        service mysql restart | mysql_indent
        ;;
    "import-database")
        [[ -z "$MYSQL_USER" ]] && { echo "!!! MySQL user is required by ${ACTION}."; exit 1; }
        [[ -z "$MYSQL_PASSWORD" ]] && { echo "!!! MySQL passwrd is required by ${ACTION}."; exit 1; }
        [[ -z "$MYSQL_DATABASE" ]] && { echo "!!! MySQL database is required by ${ACTION}."; exit 1; }
        [[ -z "$MYSQL_IMPORT_FILE" ]] && { echo "!!! MySQL SQL file is required by ${ACTION}."; exit 1; }

        echo "Importing SQL file to $MYSQL_DATABASE database: $MYSQL_IMPORT_FILE" | mysql_indent
        mysql_import_database_from_file $MYSQL_USER $MYSQL_PASSWORD $MYSQL_DATABASE $MYSQL_IMPORT_FILE | mysql_indent
        service mysql restart | mysql_indent
        ;;
    *)
        echo "!!! Unknown action for MySQL script: $ACTION"
        exit 1
        ;;
esac

