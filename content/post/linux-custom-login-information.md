+++
title = "Linux 配置自定义登录提示信息"
date = 2018-07-30T18:18:03+08:00
tags = ["linux"]
categories = ["linux-tools"]
menu = ""
disable_comments = false
banner = "cover/linux006.jpg"
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
