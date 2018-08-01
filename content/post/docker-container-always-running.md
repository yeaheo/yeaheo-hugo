+++
title = "Docker 配置容器一直运行"
date = 2018-07-29T16:57:06+08:00
tags = ["docker"]
categories = ["docker"]
menu = ""
disable_comments = false
banner = "cover/docker002.jpg"
+++

- 有时候我们需要的是当 docker 服务重启后以前运行的容器依然在运行，但是官方默认的是当 docker 服务停止后，以前运行的容器就会停止，需要重新启动
- Docker 官方参考链接：<https://docs.docker.com/engine/admin/live-restore>

- 在 Linux 系统中 Docker 服务默认的配置文件是 `/etc/docker/daemon.json`
- 编辑 `/etc/docker/daemon.json` 增加如下内容：

  ```bash
  {
    "live-restore": true
  }
  ```

- 修改完成，重启 docker 使其生效即可

  ```bash
  systemctl restart docker.service
  ```


