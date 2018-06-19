#!/bin/sh

#Author: PersiLiao(xiangchu.liao@gmail.com)
#Description: Git创建仓库并设置自动部署脚本
#Version: 1.0
#yum install -y git

GIT_ROOT=/data/git
GIT_HOST=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

function AutoCheckResult()
{
    if [ $? != 0 ]; then
        exit 1
    fi
}

function GitDeplyHookScript()
{
    GIT_REPO_HOOKS_PATH="$1/hooks"
    GIT_DEPLOY_PATH=$2
    cd ${GIT_REPO_HOOKS_PATH}
    echo '#!/bin/sh' > post-receive
    echo '' >> post-receive
    echo 'IS_BARE=$(git rev-parse --is-bare-repository)' >> post-receive
    echo 'if [ -z "$IS_BARE" ]; then' >> post-receive
    echo 'echo >&2 "fatal: post-receive: IS_NOT_BARE"' >> post-receive
    echo 'exit 1' >> post-receive
    echo 'fi' >> post-receive
    echo '' >> post-receive
    echo 'unset GIT_DIR' >> post-receive
    echo "DeployPath="${GIT_DEPLOY_PATH}"" >> post-receive
    echo 'echo "==============================================="' >> post-receive
    echo 'cd $DeployPath' >> post-receive
    echo 'git pull origin master' >> post-receive
    echo 'git reset --hard origin/master' >> post-receive
    echo '' >> post-receive
    echo 'time=`date`' >> post-receive
    echo 'echo "web server pull at webserver at time: $time."' >> post-receive
    echo 'echo "================================================"' >> post-receive
    chmod +x post-receive
    echo "Deploy Path: ${GIT_DEPLOY_PATH}"
}

function GitAddGitignore()
{
    touch .gitignore
    # 系统相关(System)
    echo '.DS_Store' > .gitignore
    # 日志(Log)
    echo '.log' >> .gitignore
    # 压缩文件(Compressed package file)
    echo '.pdf' >> .gitignore
    echo '.rar' >> .gitignore
    echo '.zip' >> .gitignore
    echo '.gz' >> .gitignore
    echo '.tgz' >> .gitignore
    echo '.tar.gz' >> .gitignore
    echo '.7z' >> .gitignore
    # Office
    echo '.doc' >> .gitignore
    echo '.docx' >> .gitignore
    echo '.xls' >> .gitignore
    echo '.xlsx' >> .gitignore
    echo '.ppt' >> .gitignore
    echo '.pptx' >> .gitignore
    # 开发工具(Development tools)
    echo '.idea' >> .gitignore
    echo '.phpintel' >> .gitignore
    echo '.vscode' >> .gitignore
    echo 'cmake-build-debug' >> .gitignore 
    echo '.cproject' >> .gitignore
    echo '.project' >> .gitignore
    echo '.settings' >> .gitignore
}

function GitAddReadme()
{
    touch README.md
}

function GitInitPush()
{
    git add "README.md" && git commit -m "add README.md"
    git add ".gitignore" && git commit -m "add .gitignore"
    git push --set-upstream origin master
}

if [ "$1" != "" ]; then
    GIT_REPO_NAME="$1"
    GIT_REPO_PATH="${GIT_ROOT}/${GIT_REPO_NAME}"
    echo "Crating repo ${GIT_REPO_NAME} at ${GIT_REPO_PATH}"
    mkdir -p ${GIT_REPO_PATH}
    AutoCheckResult
    git init --bare --share=group ${GIT_REPO_PATH}
    AutoCheckResult
    echo "Your repo is available at:"
    echo "git clone username@${GIT_HOST}:${GIT_REPO_PATH}"
else
    echo "Usage:"
    echo "  create-repo.sh Name-Of-Repo Path-Of-Deploy"
    exit 1
fi

if [ "$2" != "" ]; then
    GIT_DEPLOY_PATH=$2    
else
    GIT_DEPLOY_PATH="${GIT_ROOT}/${GIT_REPO_NAME}.deploy"
fi

GIT_DEPLOY_DIR=${GIT_DEPLOY_PATH%/*}
mkdir -p $GIT_DEPLOY_DIR
AutoCheckResult

git clone ${GIT_REPO_PATH} ${GIT_DEPLOY_PATH}
cd ${GIT_DEPLOY_PATH}
GitAddGitignore
GitAddReadme
GitInitPush

if [ "$2" != "" ]; then
    GitDeplyHookScript ${GIT_REPO_PATH} ${GIT_DEPLOY_PATH}
else
    rm -rf ${GIT_DEPLOY_PATH}
fi
