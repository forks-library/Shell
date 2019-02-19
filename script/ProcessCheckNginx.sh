#!/bin/sh

source ./ProcessCheck.sh
# 10秒钟检测一次nginx
ProcessCheck 'nginx' 'systemctl start nginx.service' 10;
