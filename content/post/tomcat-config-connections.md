+++
title = "Tomcat 连接数配置"
date = 2018-07-29T14:17:29+08:00
tags = ["tomcat"]
categories = ["tomcat"]
menu = ""
disable_comments = false
banner = "cover/tomcat002.jpg"
+++

- 在 tomcat 配置文件 `server.xml` 中的 `<Connector ... />` 配置中，和连接数相关的参数有:
- `minProcessors`     最小空闲连接线程数，用于提高系统处理性能，默认值为 10
- `maxProcessors`     最大连接线程数，即：并发处理的最大请求数，默认值为 75
- `maxThreads`        最大并发线程数，即同时处理的任务个数，默认值是 200
- `acceptCount`       允许的最大连接数，应大于等于 maxProcessors，默认值为 100
- `enableLookups`     是否反查域名，取值为：true 或 false。为了提高处理能力，应设置为 false
- `connectionTimeout` 网络连接超时,单位:毫秒.设置为 0 表示永不超时,这样设置有隐患的,通常可设置为 30000 毫秒
- 其中和最大连接数相关的参数为 maxProcessors 和 acceptCount 。如果要加大并发连接数，应同时加大这两个参数
- 下面是一个连接数设置模板
  
  ```bash
    <Connector port="8066" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" 
               maxThreads="200"
               minSpareThreads="25"
               maxSpareThreads="75"
               acceptCount="100"
               maxIdleTime="30000"
               enableLookups="false"
               compression="500"
               URIEncoding="utf-8"
               compressableMimeType="text/html,text/xml,text/javascript,text/css,text/plain,application/octet-stream"
               />
  ```

- 可以根据具体需求修改对应参数
 
     
