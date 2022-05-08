#!/bin/bash

chown -R www:www /data/logs && \

echo "logs auth ok"

if [  -d "/data/code/nulbrain/storage" ]; then
  chown -R www:www /data/code/nulbrain/storage
  echo "storage auth ok"
fi


