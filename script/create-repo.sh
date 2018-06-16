#!/bin/sh

#Author: PersiLiao(xiangchu.liao@gmail.com)
#Description: Git创建仓库并设置自动部署脚本
#Version: 1.0
#yum install -y git

GIT_ROOT=/data/git
GIT_HOST=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

GitDeplyHookScript()
{
    GIT_DEPLOY_PATH=$1
    echo '#!/bin/sh' > ./post-receive
    echo '' >> ./post-receive
    echo 'IS_BARE=$(git rev-parse --is-bare-repository)' >> ./post-receive
    echo 'if [ -z "$IS_BARE" ]; then' >> ./post-receive
    echo 'echo >&2 "fatal: post-receive: IS_NOT_BARE"' >> ./post-receive
    echo 'exit 1' >> ./post-receive
    echo 'fi' >> ./post-receive
    echo '' >> ./post-receive
    echo 'unset GIT_DIR' >> ./post-receive
    echo "DeployPath="$GIT_DEPLOY_PATH"" >> ./post-receive
    echo 'echo "==============================================="' >> ./post-receive
    echo 'cd $DeployPath' >> ./post-receive
    echo 'git pull origin master' >> ./post-receive
    echo 'git reset --hard origin/master' >> ./post-receive
    echo '' >> ./post-receive
    echo 'time=`date`' >> ./post-receive
    echo 'echo "web server pull at webserver at time: $time."' >> ./post-receive
    echo 'echo "================================================"' >> ./post-receive
    chmod +x ./post-receive
}

if [ "$1" != "" ]; then
    GIT_REPO_NAME="$1.git"
    GIT_REPO_PATH="$GIT_ROOT/$GIT_REPO_NAME"
    echo "Crating repo $GIT_REPO_NAME at $GIT_REPO_PATH"
    mkdir -p $GIT_REPO_PATH
    git init --bare --share=group $GIT_REPO_PATH
    echo "Your repo is available at:"
    echo "git clone username@$GIT_HOST:$GIT_REPO_PATH"
else
    echo "Usage:"
    echo "  create-repo.sh Name-Of-Repo Path-Of-Deploy"
fi

if [ "$2" != "" ]; then
    GIT_DEPLOY_PATH=$2
    GIT_DEPLOY_DIR=${GIT_DEPLOY_PATH%/*}
    mkdir -p $GIT_DEPLOY_DIR
    git clone $GIT_REPO_PATH $GIT_DEPLOY_PATH
    cd $GIT_DEPLOY_PATH
    touch README.md
    git add . && git commit -m "add README.md" && git push --set-upstream origin master
    cd "$GIT_REPO_PATH/hooks"
    GitDeplyHookScript $GIT_DEPLOY_PATH
    echo "Deploy Path: $GIT_DEPLOY_PATH"
fi