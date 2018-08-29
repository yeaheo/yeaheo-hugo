+++
title = "Linux 自定义 Bash 终端风格"
date = 2018-08-29T20:01:01+08:00
tags = ["linux","bash"]
categories = ["linux-tools"]
menu = ""
disable_comments = true
banner = "cover/linux008.jpg"
description = "现在大多数现代 Linux 发行版的默认 shell 都是 Bash 。然而，你可能已经注意到这样一个现象，在各个发行版中，其终端配色和提示内容都各不相同。这里我们配置 CentOS 7 的默认终端，将其改成 Kail 系统的终端风格"
+++
### 自定义 PS1 格式
默认终端都是由 PS1 控制的，这里有几个特殊字符：

```bash
\u: 显示当前用户的用户名；
\h: 完全限定域名 Fully-Qualified Domain Name（FQDN）中第一个点（.）之前的主机名；
\W: 当前工作目录的基本名，如果是位于 $HOME 家目录通常使用波浪符号简化表示（~）；
\$: 如果当前用户是 root，显示为 #，否则为 $；
\!: 显示当前命令的历史数量;
\H: 显示 FQDN 全称而不是短服务器名
```

我们也可以用 `\033[01;31m` 类型设置终端颜色，具体颜色定义可以参考下图所示：

![bash 终端颜色定义](/images/color.png "bash 终端颜色定义")

CentOS 7 自带终端内容如下：

```bash
[root@CTSIG-FILE-SERVER ~]# echo $PS1
[\u@\h \W]\$
```

我们可以对其修改，改成我们想要的效果，例如 Kail 系统风格的：


修改 `~/.bashrc` 文件，添加如下内容：

```bash
export PS1='[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m]\$ '
```
刷新本文件

```bash
source ~/.bashrc
```

显示效果:

```bash
[root@hello:~]# cd /usr/local/
[root@hello:/usr/local]# 
```
