#!/bin/bash

set -xe

echo "Checking for non existing directories"
[ ! -d "/app/Config" ] && mkdir /app/Config
[ ! -d "/app/Data" ] && mkdir /app/Data
[ ! -d "/app/Spawns" ] && mkdir /app/Spawns

echo "Setting permissions"
chown -R uo:uo /app

echo "Initialize config directories"
[ "$(ls -A /app/Config)" ] && echo "Config dir not empty. Ignoring..." || cp -r /app/Initial/Config /app/
[ "$(ls -A /app/Data)" ] && echo "Data dir not empty. Ignoring..." || cp -r /app/Initial/Data /app/
[ "$(ls -A /app/Spawns)" ] && echo "Spawns dir not empty. Ignoring..." || cp -r /app/Initial/Spawns /app/

echo "Starting UO"
cd /app
exec gosu uo mono ServUO.exe
