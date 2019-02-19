#!/bin/sh

source ./ProcessCheck.sh
# 10秒钟检测一次nginx
ProcessCheck 'mysqld' 'systemctl start mysqld.service' 10;
