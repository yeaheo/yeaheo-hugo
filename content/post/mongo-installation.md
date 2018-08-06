+++
title = "安装配置 MongoDB 数据库"
date = 2018-08-04T16:06:33+08:00
tags = ["mongodb"]
categories = ["mongodb"]
menu = ""
disable_comments = true
banner = "cover/mongo001.png"
description = "MongoDB 是一个基于分布式文件存储的数据库。由 C++ 语言编写。旨在为 WEB 应用提供可扩展的高性能数据存储解决方案。MongoDB 是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。"
+++

- MongoDB 是一个基于分布式文件存储的数据库。由 C++ 语言编写。旨在为 WEB 应用提供可扩展的高性能数据存储解决方案。
MongoDB 是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。
- MongoDB 使用教程参见：<http://www.runoob.com/mongodb/mongodb-tutorial.html>
- MongoDB 官方网站：<https://www.mongodb.com>
- MongoDB 下载地址：<https://www.mongodb.com/download-center?jmp=nav#community>

### 下载 Mongo 安装包
- 下载 mongo 安装包：
  
  ```bash
  wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.2.10.tgz
  ```

### 安装配置
- 解压安装包
  
  ```bash
  tar zxf mongodb-linux-x86_64-rhel70-3.2.10.tgz
  mv mongodb-3.2.10/ mongo320
  ```
- 创建数据库和日志目录
  
  ```bash
  mkdir -pv /usr/local/mongo320/db
  mkdir -pv /usr/local/mongo320/logs
  ```

- 准备配置文件
  
  ```bash
  vim /usr/local/mongo320/mongodb.conf
  ```
- 修改如下内容：

  ```bash
  dbpath = /usr/local/mongodb320/db
  logpath = /usr/local/mongodb320/logs/mondodb.log
  port = 27017
  fork = true
  logappend = true
  pidfilepath = /usr/local/mongodb320/mongo.pid
  bind_ip = 0.0.0.0
  #rest = true
  journal = true
  oplogSize = 2000
  cpu = true
  auth = true
  #slave = true
  #source = 192.168.8.127:27017
  ```

- 启动服务
  
  ```bash
  ln -s /usr/local/mongo320/bin/* /usr/local/bin/
  mongod -f /usr/local/mongo320/mongodb.conf
  ```

- 验证服务
  
  ```bash
  [root@localhost opt]# netstat -antpu | grep mongod
  tcp        0      0 0.0.0.0:27017           0.0.0.0:*               LISTEN      8853/mongod
  ```
- 设置相关优化参数
  
  ```bash
  echo never >>  /sys/kernel/mm/transparent_hugepage/enabled
  echo never >>  /sys/kernel/mm/transparent_hugepage/defrag
  ```
- 重启服务即可
  
