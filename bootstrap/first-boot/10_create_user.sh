#!/usr/bin/env bash

# set root pw to enable login after restart
echo "$DF_USERPASS" | passwd --stdin root
