+++
title = "FastDFS 同步延迟的问题"
date = 2018-08-14T14:25:00+08:00
tags = ["fastdfs"]
categories = ["fastdfs"]
menu = ""
disable_comments = false
banner = "cover/fdfs005.jpg"
description = "FastDFS 通过 Tracker 服务器，将文件放在 Storage 服务器存储，但是同组存储 Storage 服务器之间需要进行文件复制，有同步延迟的问题。当我们遇到即时通信的场景时，这个延迟问题是很严重的，下面通过配置 fastdfs-nginx-module 解决同步延迟的问题"
+++

FastDFS 通过 Tracker 服务器，将文件放在 Storage 服务器存储，但是同组存储服务器之间需要进入文件复制，有同步延迟的问题。

例如：

如果 Tracker 服务器将文件上传到了 192.168.8.20，上传成功后文件 ID 已经返回给客户端。此时 FastDFS 存储集群机制会将这个文件同步到同组存储 192.168.8.21 ，在文件还没有复制完成的情况下，客户端如果用这个文件 ID 在 192.168.8.21 上取文件，就会出现文件无法访问的错误。如果等待个几秒钟还是可以访问的，但这个不是我们期望的，我们的需求是上传即访问。

`fastdfs-nginx-module `可以重定向文件连接到源服务器取文件，避免客户端由于复制延迟导致的文件无法访问错误，这个就解决了我们的问题，可以使用官方提供的 nginx 插件,要使用 nginx 插件需要重新编译。下面是具体配置，可以参考一下：

之前我们安装 FastDFS 的时候有安装过 `fastdfs-nginx-module` 具体安装过程参考：[FastDFS 配置 nginx 模块](https://yeaheo.com/post/fdfs-config-nginx-module/) ,我在安装过程中没有考虑这个延迟问题，在这里补充一下。

以前我们修改的 nginx 配置文件内容为：

  
```bash
  location /group1/M00 {
    root /data/fastdfs/storage/;
    ngx_fastdfs_module;
  }
```
> 这个说明当访问 `/group1/M00` 的时候，是从本机的 `/data/fastdfs/storage/` 目录下获取的，当出现延迟问题后，上传的文件没有在这个机器上，那我们访问的时候就会报 `404` 的错误，也就是说文件未找到，其实不是没有这个文件，而是同步文件需要时间，我们要访问的文件还没同步过来呢。

我们需要对 nginx 配置文件做些修改，修改后的内容为：

```bash
location /group1/M00 {
    ngx_fastdfs_module;
}
```
> 修改后，`fastdfs-nginx-module `可以重定向文件连接到源服务器取文件，避免客户端由于复制延迟导致的文件无法访问错误。

如果我们有多个 `group` 我们可以按照如下内容修改 nginx 配置文件：

```bash
location /group([0-9])/M00 {
    ngx_fastdfs_module;
}
```

修改配置文件后重启 nginx 即可：

```bash
nginx -s reload
```
