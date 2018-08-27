+++
title = "Helm 技巧配置"
date = 2018-08-26T10:19:32+08:00
tags = ["kubernetes","helm"]
categories = ["kubernetes"]
menu = ""
disable_comments = true
banner = "cover/k8s017.png"
description = "我们在使用 Helm 管理 Kubernetes 集群应用的时候我们可以针对 Helm 做些其他配置，这样有利于我们更方便的使用 Helm 管理应用，同时也可以很方便的应用 Helm 相关功能"

+++

Helm 其他技巧配置主要包括命令行补全、添加第三方 Chart 库、解决依赖关系等等。

### Helm 命令行补全

为了方便 helm 命令的使用，helm 提供了自动补全功能，如果使用 zsh 请执行：

```bash
source <(helm completion zsh)
```

如果使用 bash 请执行：

```bash
source <(helm completion bash)
```

> 如果仅仅执行上述命令是不能达到我们预期的，当新开一个 bash 终端后是不能自动补全的，这就需要我们再做些配置，具体的就是将上述命令写到 `/etc/profile` 或者 `~/.bashrc` 文件下。

```bash
echo "source <(helm completion bash)" >> ~/.bashrc
```



### Helm 添加第三方 Chart 库

随着 Helm 越来越普及，除了使用官方存储库，我们也可以应用第三方仓库，Helm 添加第三方 Chart 库可以使用如下命令格式：

```bash
$ helm repo add <存储库名> <存储库URL>
$ helm repo update
```

例如，添加 `fabric8` 库

```bash
$ helm repo add fabric8 https://fabric8.io/helm
$ helm repo update
```

搜索 fabric8 提供的工具（主要就是 fabric8-platform 工具包，包含了CI,CD的全套工具）

```bash
$ helm search fabric8
```

除了 `fabric8` 第三方库还有其他库，我们可以根据需要添加，具体如下：

```bash
# Prometheus Operator
https://github.com/coreos/prometheus-operator/tree/master/helm

# Bitnami Library for Kubernetes
https://github.com/bitnami/charts

# Openstack-Helm
https://github.com/att-comdev/openstack-helm
https://github.com/sapcc/openstack-helm

# Tick-Charts
https://github.com/jackzampolin/tick-charts
```



### Helm 解决应用依赖

在 Chart 里可以通过 `requirements.yaml` 声明对其它 Chart 的依赖关系，例如定义对`mariadb`的依赖：：

```bash
dependencies:
- name: mariadb
  version: 0.6.0
  repository: https://kubernetes-charts.storage.googleapis.com
```

如果有多个依赖应用只需在下面继续添加即可，也就是说可以定义多个 `name`，修改完成后使用`helm lint .`命令可以检查依赖和模板配置是否正确。



### Helm 支持多环境

Chart 是支持参数替换的，可以把业务配置相关的参数设置为模板变量。使用 `helm install` 命令部署的时候指定一个参数值文件，这样就可以把业务参数从 Chart 中剥离了。例如： `helm install --values=values-production.yaml wordpress`。



### Helm 连接到指定 Kubernetes 集群

Helm 默认使用和 kubectl 命令相同的配置访问 Kubernetes 集群，其配置默认在 `~/.kube/config` 中。



### Helm 部署时指定 NAMESPACE

`helm install` 默认情况下是部署在 default 这个命名空间的。如果想部署到指定的命令空间，可以加上 `--namespace` 参数，例如：

```bash
helm install local/mychart --name helm-test --namespace <namespace>
```



### Helm 查看应用详细信息

我们可以使用如下命令查看已部署应用的详细信息：

```bash
$ helm get helm-test
```

默认情况下会显示最新的版本的相关信息，如果想要查看指定发布版本的信息可加上 `--revision` 参数。例如：

```bash
$ helm get  --revision 1  helm-test
```



### Helm 应用 CI/CD

采用 Helm 可以把零散的 Kubernetes 应用配置文件作为一个 Chart 管理，Chart 源码可以和源代码一起放到 Git 库中管理。通过把 Chart 参数化，可以在测试环境和生产环境采用不同的 Chart 参数配置。