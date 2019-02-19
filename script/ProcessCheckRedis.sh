#!/bin/sh

source ./ProcessCheck.sh
# 10秒钟检测一次nginx
ProcessCheck 'redis' 'systemctl start redis.service' 10;
