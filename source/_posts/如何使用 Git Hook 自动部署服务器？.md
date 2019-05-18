---
title: 如何使用 Git Hook 自动部署服务器？
tags:
  - 技术
  - Git
abbrlink: f73a702f
date: 2017-06-20 02:45:02
---
> 一行命令，自动将本地文件部署到远程服务器上。

<!-- more -->

最近搭了个个人网站，在放到服务器上时，考虑到，如果每次更新的内容，都要用 FTP 或者别的文件传输方式，将文件一个个的放到服务器上，简直是太麻烦了，有没有什么办法更好，更快的完成部署呢？

使用 Git Hooks（Git 钩子），可以做到这点。Git Hooks 是什么？「Git 能在特定的重要动作发生时触发自定义脚本」，比如说`pre-commit`, `post-receive`等等，在这些动作之前或者之后，会运行定义好的脚本。要做到自动部署，就是要用到这个 `post-receive`。

**在设置自动部署前，先要设置无密码登录远程服务器，具体操作可以参考这篇文章。[ SSH Key 无密码登录服务器 ]**

## 自动部署
整个流程大概是：在服务器端创建一个 Git 仓库(repository)，然后将本地的文件使用 `git push` 上传到这个仓库后，将上传到Git 仓库的文件，自动复制到服务器里网页运行的文件夹下。

1. 在服务器端，创建一个 Git 仓库，
```
git init --bare website.git
```

2. 创建 `post-receive`文件
```
cd website.git
vim hooks/post-receive
```

  将以下内容复制到`post-receive`文件里
```
#!/bin/bash -l
GIT_REPO=/home/git/website.git
TMP_GIT_CLONE=/tmp/website
PUBLIC_WWW=/var/www/zhuangweiming.me/html
rm -rf ${TMP_GIT_CLONE}
git clone $GIT_REPO $TMP_GIT_CLONE
cd $TMP_GIT_CLONE
rm -rf ${PUBLIC_WWW}/*
cp -rf ${TMP_GIT_CLONE}/* ${PUBLIC_WWW}
```

  代码解释：
`rm -rf ${TMP_GIT_CLONE} `清空临时路径里面的内容
`git clone $GIT_REPO $TMP_GIT_CLONE `将 Git 仓库的内容克隆到临时路径
`rm -rf ${PUBLIC_WWW}/* `清空服务器网页存放文件夹
`cp -rf ${TMP_GIT_CLONE}/* ${PUBLIC_WWW} `将临时路径里的文件复制到服务器网页存放路径

3. 给 `post-receive` 文件授权
```
chmod +x hooks/post-receive
```

4. 本地添加 Git 远程仓库，测试
```
git remote add deploy ssh://git@128.199.169.239/home/git/website.git
git push deploy
```

## 自动部署指定的 Git branch
如果是要部署特定的 branch，在上述第二部中，将 `post-receive` 的文件内容替换为：
```
#!/bin/bash -l
while read oldrev newrev ref
do
  branch=`echo $ref | cut -d/ -f3`
  if [ "master" == "$branch" ] || [ "production" == "$branch" ]; then
    GIT_REPO=/home/git/website.git
    TMP_GIT_CLONE=/tmp/website
    PUBLIC_WWW=/var/www/zhuangweiming.me/html
    rm -rf ${TMP_GIT_CLONE}
    git clone $GIT_REPO $TMP_GIT_CLONE
    cd $TMP_GIT_CLONE
    unset GIT_DIR
    git checkout $branch
    rm -rf ${PUBLIC_WWW}/*
    cp -rf ${TMP_GIT_CLONE}/* ${PUBLIC_WWW}
  fi
done
```
