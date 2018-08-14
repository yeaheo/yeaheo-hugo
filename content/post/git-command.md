+++
title = "Git 常用命令总结"
date = 2018-08-03T16:06:09+08:00
tags = ["git"]
categories = ["git"]
menu = ""
disable_comments = false
banner = "cover/git001.png"
description = "Git是一个开源的分布式版本控制系统，用于敏捷高效地处理任何或小或大的项目。Git 是 Linus Torvalds 为了帮助管理 Linux 内核开发而开发的一个开放源码的版本控制软件。Git 与常用的版本控制工具 CVS, Subversion 等不同，它采用了分布式版本库的方式，不必服务器端软件支持。"
+++
- Git是一个开源的分布式版本控制系统，用于敏捷高效地处理任何或小或大的项目。Git 是 Linus Torvalds 为了帮助管理 Linux 内核开发而开发的一个开放源码的版本控制软件。Git 与常用的版本控制工具 CVS, Subversion 等不同，它采用了分布式版本库的方式，不必服务器端软件支持。

### 创建版本库

```bash
git init                                # 在指定目录下执行，初始化本地版本仓库
git clone <url>                         # 将远程仓库下载到本地
```

### 修改和提交

```bash
git status
git diff                                # 查看变更内容（未提交的文件）
git diff --staged                       # 查看变更内容（已提交的文件）
git add .                               # 跟踪当前目录下的所有文件
git add <file>                          # 跟踪指定文件
git mv  <old_name>  <new_name>          # 文件重命名
git rm  <file>                          # 删除文件，删除后需要重新提交，原文件被删除
git rm --cached <file>                  # 停止跟踪文件但不删除原文件
git commit -m "commit message"          # 提交所有更新过的文件
git commit --amend                      # 修改最后一次提交(重新提交)
```

### 查看提交历史

```bash
git log                                 # 查看整个提交系统
git log -p <file>                       # 查看指定文件的提交历史
git log --prety=oneline                 # 查看只显示一行的提交历史(亦可增加其他参数)
git blame <file>                        # 以列表方式查看指定文件的提交历史
git rev-parse --short HEAD              # 获取最新一次提交的短 ID
```

### 撤销操作

```bash
git checkout -- <file>                  # 撤销指定文件的未提交的更改
git checkout HEAD <file>                # 同上(撤销指定文件的未提交的更改)
git reset HEAD <file>                   # 撤销暂存区指定文件的修改
git reset --hard HEAD                   # 撤销工作目录下所有未提交文件的修改内容
git revert <commit>                     # 撤销指定的提交
```

### 分支与标签

```bash
git branch                              # 查看分支
git branch -a                           # 查看远程分支
git branch <branch_name>                # 新建分支
git branch -d <branch_name>             # 删除某个分支
git checkout <branch_name>              # 切换到某个分支
git checkout -b <branch_name>           # 新建并切换分支

git tag                                 # 查看标签
git tag <tag_name>                      # 新建标签（轻量标签）
git tag -a <tag_name> -m "tag message"  # 新建标签（附注标签）
git show <tag_name>                     # 查看指定标签信息
git tag -d <tag_name>                   # 删除标签
```

### 合并与衍生

```bash
git merge <branch_name>                 # 合并指定分支到当前分支
git rebase <branch_name>                # 衍生指定分支到当前分支(可以快进合并分支)
```

### 远程仓库操作

```bash
git remote -v                           # 查看远程版本库信息
git remote show <remote>                # 查看指定远程版本库详细信息
git remote add <remote> <URL>           # 添加远程版本库
git fetch <remote>                      # 从远程库获取代码(只是获取远程内容，未合并，需要手动合并)
git pull <remote> <branch>              # 从远程仓库更新并快速合并
git push <remote> <branch>              # 上传代码并快速合并
git push <remote> :<branch/tag>         # 删除远程分支或标签
git push <remote> --delete <branch/tag> # 删除远程分支或标签(同上)
git push --tags                         # 上传所有标签到远程仓库
```

> 上述 GIT 相关命令只是常用的几个，陆续更新中...