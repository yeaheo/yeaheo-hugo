+++
title = "利用 docker 安装 nexus3 私服"
date = 2018-08-09T19:06:53+08:00
tags = ["docker","nexus3"]
categories = ["docker"]
menu = ""
disable_comments = false
banner = "cover/nexus001.png"
description = "在本篇文章我们要向大家介绍的正是 Sonatype Nexus 3 这个强大的工具，它不仅仅能够用于创建 Maven 私服，还可以用来创建 bower、npm、nuget、pypi、rubygems 等各种私有仓库，受到 docker 技术不断被追捧的影响，Nexus 从 3.0 版本也开始支持创建 Docker 镜像仓库了。"
+++

在本篇文章我们要向大家介绍的正是 Sonatype Nexus 3 这个强大的工具，它不仅仅能够用于创建 Maven 私服，还可以用来创建 bower、npm、nuget、pypi、rubygems 等各种私有仓库，受到 docker 技术不断被追捧的影响，Nexus 从 3.0 版本也开始支持创建 Docker 镜像仓库了。本文档主要说明用 docker 如何安装 nexus3 仓库。

nexus3.x 官网下载地址: <https://www.sonatype.com/download-oss-sonatype>
  
  > 在这里由于我们需要用到 nexus3 的镜像，这里不再下载二进制软件安装包。

nexus3 的镜像名称为 `sonatype/nexus3` 我们直接用 docker 工具下载即可：
  ```bash
  docker pull sonatype/nexus3
  ```

为了加快速度，建议安装镜像加速器，具体参见 [docker 配置镜像加速器](https://yeaheo.com/post/docker-image-accelerator-installation/)

### 运行容器

当我们下载了 `sonatype/nexus3` 镜像后，我们需要借助此镜像起容器，还需要将公开的端口 8081 映射到宿主机，具体启动命令如下：
  ```bash
  docker run -d -p 8081:8081 --name nexus sonatype/nexus3
  ```

容器启动后，稍等 3-5 分钟，然后用如下命令进行简单测试：
  ```bash
  [root@ns1 ~]# curl -u admin:admin123 http://localhost:8081/service/metrics/ping
  pong
  ```

  > nexus3 的默认登录账号/密码为 `admin/admin123`，登录成功后我们可以自定义修改。

当出现上述 `pong` 后表示运行正常。

在容器启动过程中可以查看容器启动日志：
  ```bash
  docker logs -f nexus
  ```

### 容器相关变量

对于 nexus 容器，我们需要知道如下信息：

Nexus 的安装目录是 `/opt/sonatype/nexus`；

Nexus 用于持久性存放日志及存储的目录是 `/nexus-data`，此目录需要由 Nexus 进程写入，该进程以 `UID 200`运行；

有一个环境变量用于将 JVM 参数传递给启动脚本，`INSTALL4J_ADD_VM_PARAMS`，传递给 `Install4J` 启动脚本。默认为 `-Xms1200m -Xmx1200m -XX:MaxDirectMemorySize=2g -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs`；

针对上述配置，我们可以调整容器启动命令：
  ```bash
  docker run -d -p 8081:8081 --name nexus -e INSTALL4J_ADD_VM_PARAMS="-Xms2g -Xmx2g -XX:MaxDirectMemorySize=3g  -Djava.util.prefs.userRoot=/some-other-dir" sonatype/nexus3
  ```
  
  > 特别值得注意的是，`-Djava.util.prefs.userRoot=/some-other-dir` 可以将其设置为持久路径，如果重新启动容器，将保留已安装的 Nexus 存储库许可证。

另一个环境变量可用于控制 Nexus 上下文路径，`NEXUS_CONTEXT`，默认为 `/` ,如果需要修改上下文路径，可以参考如下命令：
  ```bash
  docker run -d -p 8081:8081 --name nexus -e NEXUS_CONTEXT=nexus sonatype/nexus3
  ```

### 持久化数据
使用 docker 持久化数据一般有两种方式：1、数据卷 2、将宿主机目录挂载为卷，下面我们将分别介绍这两种方式。

**数据卷**

由于 docker 数据卷是持久性的，因此可以专门为此目的创建卷，我们推荐此方式。
创建数据卷：
  ```bash
  docker volume create --name nexus-data
  ```

运行容器并挂载数据卷
  ```bash
  docker run -d -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3
  ```

**将宿主机目录挂载为卷**

将宿主机目录挂载为卷不可移植，因为它需要在主机上具有正确权限的目录。但是，在需要将此卷分配给某些特定底层存储的某些情况下，它还是具有很大意义的。
新建挂载相关目录并授权
  ```bash
  mkdir /some/dir/nexus-data && chown -R 200 /some/dir/nexus-data
  ```

运行容器并挂载相关目录：
  ```bash
  docker run -d -p 8081:8081 --name nexus -v /some/dir/nexus-data:/nexus-data sonatype/nexus3
  ```

当容器启动后我们可以用浏览器尝试登录，地址是 `http://ip:8081`,账号密码默认为 `admin/admin123`。登录成功后我们就可以建立我们自己的私有仓库了，包括 maven、 npm、 甚至是 docker 私有镜像仓库，后续会更新具体操作方法。

