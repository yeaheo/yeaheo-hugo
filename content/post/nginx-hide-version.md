+++
title = "Nginx 隐藏版本号"
date = 2018-07-29T16:58:45+08:00
tags = ["nginx"]
categories = ["nginx"]
menu = ""
disable_comments = false
banner = "cover/nginx004.jpg"
description = "有时候，我们用的 ngixn 访问的时候会出现 nginx 的版本号，这样是不安全的，有些人会利用某些版本的 nginx 的漏洞对我们的网站进行攻击，为了比较安全的应用 nginx 我们这里介绍如何隐藏 nginx 的版本号。"
+++

- 修改前测试如下：
  
  ```bash
  [root@test-node1 ~]# curl -I http://127.0.0.1
  HTTP/1.1 302 Found
  Server: nginx/1.12.0
  Date: Sat, 22 Jul 2017 10:01:01 GMT
  Content-Type: text/plain; charset=utf-8
  Connection: keep-alive
  Location: /login
  Set-Cookie: grafana_sess=e7badd2607d1c42c; Path=/; HttpOnly
  Set-Cookie: redirect_to=%252F; Path=/
  ```

- 修改 nginx 配置文件，默认在 `/usr/local/nginx/conf` 目录下
  
  ```bash
  vim /usr/local/nginx/conf/nginx.conf
  ```

- 在 `http{}` 段内添加 `server_tokens off;`
- 重新加载 nginx 配置文件
  
  ```bash
  nginx -s reload
  ```

- 配置完成测试如下：

  ```bash
  [root@test-node1 ~]# curl -I http://127.0.0.1
  HTTP/1.1 302 Found
  Server: nginx                  # 修改后版本号隐藏了
  Date: Sat, 22 Jul 2017 10:05:25 GMT
  Content-Type: text/plain; charset=utf-8
  Connection: keep-alive
  Location: /login
  Set-Cookie: grafana_sess=1433bef4a430a2b2; Path=/; HttpOnly
  Set-Cookie: redirect_to=%252F; Path=/
  ```
  

