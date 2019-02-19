#!/bin/sh

# 定时检测进程并重启, ProcessCheck nginx /usr/local/nginx/bin/nginx 20
function ProcessCheck()
{
    Step=$3
    if [ $Step -gt 60 ]; then
        echo '间隔秒数不能超过60,当前间隔秒数为:'$Step
        exit 0
    fi

    ProcessName=$1
    ProcessMustNum=1
    RunCommand=$2
    for (( i = 0; i < 60; i=(i+$Step) )); do
        ProcessRunNum=`ps -ef | grep -v grep | grep $ProcessName | wc -l`
        if [ $ProcessRunNum -lt $ProcessMustNum ]; then
            RunResult=`$RunCommand`
            if [ $? -ne 0 ]; then
                echo $RunCommand 'error';
            fi
        fi
        sleep $Step
    done
    exit 0
}
