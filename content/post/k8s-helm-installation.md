+++
title = "Helm 简单部署"
date = 2018-08-18T19:50:53+08:00
tags = ["kubernetes","helm"]
categories = ["kubernetes"]
menu = ""
disable_comments = true
banner = "cover/k8s014.png"
description = "Helm Chart 是用来封装 Kubernetes 原生应用程序的一系列 YAML 文件。可以在你部署应用的时候自定义应用程序的一些 Metadata，以便于应用程序的分发。 本文档我们尝试安装 Helm，具体内容如下："

+++

Helm Chart 是用来封装 Kubernetes 原生应用程序的一系列 YAML 文件。可以在你部署应用的时候自定义应用程序的一些 Metadata，以便于应用程序的分发。

Helm 的安装方式很多，这里采用二进制的方式安装。更多安装方法可以参考 [Helm 的官方帮助文档](https://docs.helm.sh/)。

安装 Helm 也可以参考 [GitHub 官方文档](https://github.com/helm/helm/blob/master/docs/install.md)



### 安装 Helm 客户端

**使用官方提供的脚本一键安装**

```bash
$ curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```

**手动下载二进制文件安装**

```bash
# Helm 安装版本为 v2.9.1，其他版本类似

# 下载 Helm
$ wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
# 解压 Helm
$ tar -zxvf helm-v2.9.1-linux-amd64.tar.gz
# 复制客户端执行文件到 bin 目录下
$ cp linux-amd64/helm /usr/local/bin/
```



### 安装 Helm 服务端 Tiller

Tiller 是以 Deployment 方式部署在 Kubernetes 集群中的，只需使用以下指令便可简单的完成安装。 

```bash
helm init --upgrade
```

在缺省配置下， Helm 会利用 `gcr.io/kubernetes-helm/tiller`  镜像在 Kubernetes 集群上安装配置 Tiller；并且利用 "https://kubernetes-charts.storage.googleapis.com" 作为缺省的 `stable repository`  的地址。由于在国内可能无法访问 "gcr.io"，"storage.googleapis.com" 等域名，阿里云容器服务为此提供了镜像站点。

更换阿里云镜像站点如下：

```bash
# 配置阿里云镜像安装并把默认仓库设置为阿里云上的镜像仓库
$ helm init --upgrade --tiller-image registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.9.1 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
```

安装成功完成后，将看到如下类似信息输出： 

```bash
$ helm init --upgrade
$HELM_HOME has been configured at /Users/test/.helm.

Tiller (the helm server side component) has been installed into your Kubernetes Cluster.
Happy Helming!
```

 

### 为 Tiller 授权

自Kubernetes 1.6 版本开始，API Server 启用了 RBAC 授权。而目前的 Tiller 部署没有定义授权的 ServiceAccount ，这会导致访问 API Server 时被拒绝。我们可以采用如下方法，明确为 Tiller 部署添加授权。 

- 创建 Kubernetes 的服务帐号和角色绑定：

```bash
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
```

- 为 Tiller 设置帐号：

```bash
# 使用 kubectl patch 更新 API 对象
$ kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
deployment.extensions "tiller-deploy" patched
```

-  查看是否授权成功:

```bash
$ kubectl get deploy --namespace kube-system tiller-deploy --output yaml | grep serviceAccount
      serviceAccount: tiller
      serviceAccountName: tiller
```

> 当出现上述信息表示已经授权成功！



### 验证 Tiller 是否安装成功

当 Helm 和 Tiller 安装完成并且已经授权成功后，可以通过 `kubectl` 检查是否安装完成：

```bash
$ kubectl get pods -n kube-system | grep tiller
tiller-deploy-7fdbf6766f-w9wd9          1/1       Running   0          2d

$ helm version
Client: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
```

> 有时候当我们执行 `helm version` 时，会输出连接 `Server` 端时和 `socat` 相关的报错的信息，这是我们没有安装 `socat` 软件，我们需要在所有集群节点上安装 `socat` 

在所有节点上安装 `socat` :

```bash
$ yum install socat -y
```

当安装完成后再执行 `helm version` 一般就不会报错了，当输出类似如下信息时表示 Helm 和 Tiller 安装成功。

```bash
$ helm version
Client: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.9.1", GitCommit:"20adb27c7c5868466912eebdf6664e7390ebe710", GitTreeState:"clean"}
```

 