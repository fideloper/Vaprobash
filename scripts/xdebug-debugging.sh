#!/usr/bin/env bash

echo ">>> Enabling xdebug debugging"

xdebugini="/etc/php5/mods-available/xdebug.ini"

# find xdebug extension
xdebugso=$(find /usr/lib/php5/ -name 'xdebug.so' | tail -1)

# xdebug extension exists
if [[ -n $xdebugso ]];
then

  # we want to write only not yet existing xdebug options

  # specify extension location
  if ! grep -q -s "zend_extension" "$xdebugini";
  then
    echo "zend_extension=\"$xdebugso\"" >> "$xdebugini"
  fi

  # enable remote debugging
  if ! grep -q -s "xdebug.remote_enable" "$xdebugini";
  then
    echo "xdebug.remote_enable = on" >> "$xdebugini"
  fi

  # specify remote handler
  if ! grep -q -s "xdebug.remote_handler" "$xdebugini";
  then
    echo "xdebug.remote_handler = dbgp" >> "$xdebugini"
  fi

  # enable connect_back so we don't have to specify host IP
  if ! grep -q -s "xdebug.remote_connect_back" "$xdebugini";
  then
    echo "xdebug.remote_connect_back = on" >> "$xdebugini"
  fi

  # put log in /tmp dir so we can debug our debugger in case
  # something doesn't work
  if ! grep -q -s "xdebug.remote_log" "$xdebugini";
  then
    echo "xdebug.remote_log = /tmp/xdebug.log" >> "$xdebugini"
  fi

fi;

sudo service apache2 restart
