+++
title = "Linux 配置自定义登录提示信息"
date = 2018-07-30T18:18:03+08:00
tags = ["linux"]
categories = ["linux-tools"]
menu = ""
disable_comments = true
banner = "cover/linux006.jpg"
description = "当我们通过远程工具登录 Linux 服务器的时候，首先会出现登录提示信息，具体包括登录时间，登录 IP 地址等，有的时候还会看到最近一次登录失败的信息，但是有时候还需要我们自定义自己的登录信息，可以做些提示信息，也可以将管理员的联系方式写上去。"
+++

- Linux 服务器默认登录提示信息如下所示：
  
  ```bash
  Last login: Tue Nov 14 14:37:02 2017 from xx.xxx.xx.xxx
  ```
- **配置自定义登录提示信息**
- 需要自定义登录提示信息，需要编辑 `/etc/motd` 文件，默认此文件为空，我们只需要把我们需要登录时提示的信息加到里面即可。
- **例如:** 
  
  ```bash
  vim /etc/motd
  ```
- 添加如下信息：
  
  ```bash
  Authorized users only. All activity may be monitored and reported
  ```
- 保存退出即可！
