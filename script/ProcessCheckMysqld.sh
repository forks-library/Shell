#!/bin/sh

source /home/persi/crontab/shell/ProcessCheck.sh
# 10秒钟检测一次nginx
ProcessCheck 'mysqld' 'systemctl start mysqld.service' 10;
