#!/bin/sh

source ./ProcessCheck.sh
# 10秒钟检测一次nginx
ProcessCheck 'php-fpm' 'systemctl start php-fpm.service' 10;
