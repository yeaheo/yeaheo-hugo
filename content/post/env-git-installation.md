+++
title = "CentOS 7 系统上安装较新版本的 git 工具"
date = 2018-07-25T19:45:50+08:00
tags = ["git"]
categories = ["git"]
menu = ""
disable_comments = false
banner = "cover/blog009.png"
description = "Git 是一个开源的分布式版本控制系统，用于敏捷高效地处理任何或小或大的项目。与常用的版本控制工具 CVS、Subversion 等不同，它采用了分布式版本库的方式，不必服务器端软件支持。但有时候也需要我们安装较新版本的 git"
+++

- 有些时候我们需要安装较新版本的 git 工具，因为有的操作需要在 git 较新版本的基础上才能正常运行。
- 系统版本信息：
  
    ```bash
    [root@ns1 ~]# cat /etc/redhat-release 
    CentOS Linux release 7.5.1804 (Core)
    ```

- git 官方地址：<https://git-scm.com/>
- git 源码官方下载地址：<https://mirrors.edge.kernel.org/pub/software/scm/git/>

### 源码安装 git
- 获取源码包(根据自己需要下载指定版本的源码包):
  
    ```bash
    cd /opt/soft
    wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.13.6.tar.gz
    ```
  
- 安装相关依赖包：

    ```bash
    yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker openssh-clients -y
    ```
 
- 编译并安装:

    ```bash
    tar xf /opt/soft/git-2.13.6.tar.gz -C /usr/src
    cd /usr/src/git-2.13.6
    make prefix=/usr/local/git all   # prefix 参数用于指定 git 安装目录
    make prefix=/usr/local/git install
    ```

- 设置相关环境变量：
- 修改 `/etc/profile` 文件，增加如下内容：

    ```bash
    export GIT_HOME=/usr/local/git
    export PATH=$PATH:$GIT_HOME/bin
    ```

- 执行 `/etc/profile` 文件使配置生效：

    ```bash
    source /etc/profile
    ```
- 安装完成验证 git ：

    ```bash
    [root@ns1 ~]# git --version 
    git version 2.13.6
    ```

### 配置 git 客户端自动补全
- 当我们在 Linux 系统上安装 git 后，默认是不能自动补全的，需要我们配置一下：

    ```bash
    cd /usr/src/git-2.13.6
    cp contrib/completion/git-completion.bash /etc/bash_completion.d/
    bash /etc/bash_completion.d/git-completion.bash
    ```

- 编辑 `/etc/profile` 文件，加入如下内容：

    ```bash
    # Git bash autoload
    if [ -f /etc/bash_completion.d/git-completion.bash ]; then
    . /etc/bash_completion.d/git-completion.bash
    fi
    ```

- 执行 `/etc/profile` 文件使配置生效：

    ```bash
    source /etc/profile
    ```

- 再次验证即可发现 git 客户端可以自动补全了。