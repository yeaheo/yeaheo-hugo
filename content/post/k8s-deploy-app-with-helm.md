+++
title = "Helm 部署应用到 Kubernetes 集群"
date = 2018-08-27T11:13:45+08:00
tags = ["kubernetes","helm"]
categories = ["kubernetes"]
menu = ""
disable_comments = true
banner = "cover/k8s016.jpg"
description = "当我们设置完 Chart 配置并将其发布到 Repositry 后就可以使用 helm install 命令 将应用发布到 Kubernetes 集群中，发布完成后还可以用 Helm 管理对应的 Kubernetes 应用，可以进行版本的升级和回滚等操作 "

+++

当我们设置完 Chart 配置并将其发布到 Repositry 后就可以使用 helm install 命令 将应用发布到 Kubernetes 集群中，发布完成后还可以用 Helm 管理对应的 Kubernetes 应用，可以进行版本的升级和回滚等操作。

### 检查配置和模板是否有效

当使用 `helm install` 命令部署应用时，实际上就是将 templates 目录下的模板文件渲染成 Kubernetes 能够识别的 YAML 格式。

当我们修改好 Chart 文件后，可以用如下命令检查配置和模板是否有效：

```bash
$ helm install --dry-run --debug <chart_dir> --name <release_name>
```

上述命令输出中包含了模板的变量配置与最终渲染的 YAML 文件，例如：

```bash
$ helm install --dry-run --debug mychart

[debug] Created tunnel using local port: '36589'

[debug] SERVER: "127.0.0.1:36589"

[debug] Original chart version: ""
[debug] CHART PATH: /opt/workspace/mychart

NAME:   youngling-flee
REVISION: 1
RELEASED: Mon Aug 27 10:56:07 2018
CHART: mychart-0.1.0
USER-SUPPLIED VALUES:
{}

COMPUTED VALUES:
affinity: {}
image:
  pullPolicy: IfNotPresent
  repository: nginx
  tag: stable
ingress:
  annotations: {}
  enabled: false
  hosts:
  - chart-example.local
  path: /
  tls: []
nodeSelector: {}
replicaCount: 1
resources: {}
service:
  port: 80
  type: ClusterIP
tolerations: []

HOOKS:
MANIFEST:

---
# Source: mychart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: youngling-flee-mychart
  labels:
    app: mychart
    chart: mychart-0.1.0
    release: youngling-flee
    heritage: Tiller
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app: mychart
    release: youngling-flee
---
# Source: mychart/templates/deployment.yaml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: youngling-flee-mychart
  labels:
    app: mychart
    chart: mychart-0.1.0
    release: youngling-flee
    heritage: Tiller
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mychart
      release: youngling-flee
  template:
    metadata:
      labels:
        app: mychart
        release: youngling-flee
    spec:
      containers:
        - name: mychart
          image: "nginx:stable"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {}
```



### 部署应用到 Kubernetes 集群

验证完成没有问题后，我们就可以使用以下命令将其部署到 Kubernetes 上了:

```bash
# 部署时需指定 Chart 名及 Release（部署的实例）名。
$ helm install local/mychart --name helm-test
NAME:   helm-test
LAST DEPLOYED: Mon Aug 27 11:28:28 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME               TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)  AGE
helm-test-mychart  ClusterIP  10.254.128.14  <none>       80/TCP   3s

==> v1beta2/Deployment
NAME               DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
helm-test-mychart  1        0        0           0          3s


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=mychart,release=helm-test" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80
```

> 上述命令也可以在`mychart`目录下执行 `helm install .`将 nginx 部署到 kubernetes 集群上

现在 nginx 已经部署到 kubernetes 集群上，本地执行提示中的命令在本地主机上访问到 nginx 实例：

```bash
$ export POD_NAME=$(kubectl get pods --namespace default -l "app=mychart,release=helm-test" -o jsonpath="{.items[0].metadata.name}")
$ echo "Visit http://127.0.0.1:8080 to use your application"
$ kubectl port-forward $POD_NAME 8080:80
```

具体访问效果如下图所示：

```bash
$ curl -s http://127.0.0.1:8090
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```



### 查看部署的 Release

当部署 Release 到 Kubernetes 集群后，可以使用下面的命令列出的所有已部署的 Release 以及其对应的 Chart：

```bash
$ helm list
NAME     	REVISION	UPDATED                 	STATUS  	CHART        	NAMESPACE
helm-test	1       	Mon Aug 27 11:28:28 2018	DEPLOYED	mychart-0.2.0	default  
```

不仅如此，我们还可以用下面命令查看某个 Release 的具体状态：

```bash
$ helm status helm-test
LAST DEPLOYED: Mon Aug 27 11:28:28 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME               TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)  AGE
helm-test-mychart  ClusterIP  10.254.128.14  <none>       80/TCP   11m

==> v1beta2/Deployment
NAME               DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
helm-test-mychart  1        1        1           1          11m

==> v1/Pod(related)
NAME                                READY  STATUS   RESTARTS  AGE
helm-test-mychart-6cdfc4d97c-vbwx5  1/1    Running  0         11m


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=mychart,release=helm-test" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80
```



### 升级及回退某一个应用

从上面 `helm list` 输出的结果中我们可以看到有一个 Revision（更改历史）字段，该字段用于表示某一个 Release 被更新的次数，我们可以用该特性对已部署的 Release 进行更新。

**模拟应用升级**

首先，需要修改 `Chart.yaml` 文件，将应用版本从 `0.2.0` 修改为 `0.3.0` ，然后使用 `helm package` 命令打包并发布到本地仓库：

```bash
$ cd mychart/
$ cat Chart.yaml 
apiVersion: v1
appVersion: "1.0"
description: A Helm chart for Kubernetes
name: mychart
version: 0.3.0

$ helm package mychart
Successfully packaged chart and saved it to: /opt/workspace/mychart-0.3.0.tgz
```

查询本地仓库版本：

```bash
$ helm search mychart -l
NAME         	CHART VERSION	APP VERSION	DESCRIPTION                
local/mychart	0.3.0        	1.0        	A Helm chart for Kubernetes
local/mychart	0.2.0        	1.0        	A Helm chart for Kubernetes
local/mychart	0.1.0        	1.0        	A Helm chart for Kubernetes
```

升级应用

用 `helm upgrade` 命令将已部署的 helm-test 升级到新版本:

```bash
$ helm upgrade helm-test local/mychart
Release "helm-test" has been upgraded. Happy Helming!
```

> 你可以通过 `--version` 参数指定需要升级的版本号，如果没有指定版本号，则默认使用最新版本

升级完成后再次查看，注意观察 `Revision` 字段：

```bash
$ helm list
NAME     	REVISION	UPDATED                 	STATUS  	CHART        	NAMESPACE
helm-test	2       	Mon Aug 27 11:58:10 2018	DEPLOYED	mychart-0.3.0	default  
```

可以看到 `Revision` 字段由原来的 1 变成了 2，`Chart` 字段也由 `mychart-0.2.0` 升级到了 `mychart-0.3.0` ,表示升级完成。



**模拟回退应用**

如果更新后的程序运行有问题，需要回退到旧版本的应用。当遇到这种问题后我们可以使用 `helm history` 命令查看一个 Release 的所有变更记录：

```bash
$ helm history helm-test
REVISION	UPDATED                 	STATUS    	CHART        	DESCRIPTION     
1       	Mon Aug 27 11:28:28 2018	SUPERSEDED	mychart-0.2.0	Install complete
2       	Mon Aug 27 11:58:10 2018	DEPLOYED  	mychart-0.3.0	Upgrade complete
```

当我们知道了应用的变更记录后，我们可以选择回退应用到指定版本：

```bash
$ helm rollback helm-test 1
Rollback was a success! Happy Helming!
```

> 其中的参数 1 是 helm history 查看到 Release 的历史记录中 REVISION 对应的值

再次查看 Release 的变更记录：

```bash
$ helm history helm-test
REVISION	UPDATED                 	STATUS    	CHART        	DESCRIPTION     
1       	Mon Aug 27 11:28:28 2018	SUPERSEDED	mychart-0.2.0	Install complete
2       	Mon Aug 27 11:58:10 2018	SUPERSEDED	mychart-0.3.0	Upgrade complete
3       	Mon Aug 27 12:06:26 2018	DEPLOYED  	mychart-0.2.0	Rollback to 1   
```

再次查看现有 Release ：

```bash
$ helm list
NAME     	REVISION	UPDATED                 	STATUS  	CHART        	NAMESPACE
helm-test	3       	Mon Aug 27 12:06:26 2018	DEPLOYED	mychart-0.2.0	default  
```

可以看到 `Revision` 字段由原来的 2 变成了 3，`Chart` 字段也由 `mychart-0.3.0` 回退到了 `mychart-0.2.0` ,表示回退应用完成。



### 删除应用

删除应用比较方便，如果需要删除一个已部署的 Release，可以利用 `helm delete` 命令来完成删除：

```bash
$ helm delete helm-test
release "helm-test" deleted
$ helm list
```

当我们删除应用后我们可以使用如下命令查看被删除应用的状态：

```bash
$ helm list -a
NAME     	REVISION	UPDATED                 	STATUS 	CHART        	NAMESPACE
helm-test	3       	Mon Aug 27 12:06:26 2018	DELETED	mychart-0.2.0	default  
```

由上述内容可知被删除的应用已经被标记为 `DELETED` 状态。

也可以使用 `--deleted` 参数来列出已经删除的 Release ：

```bash
$ helm list --deleted 
NAME     	REVISION	UPDATED                 	STATUS 	CHART        	NAMESPACE
helm-test	3       	Mon Aug 27 12:06:26 2018	DELETED	mychart-0.2.0	default  
```

查看被删除应用的历史变更记录：

```bash
$ helm history helm-test
REVISION	UPDATED                 	STATUS    	CHART        	DESCRIPTION      
1       	Mon Aug 27 11:28:28 2018	SUPERSEDED	mychart-0.2.0	Install complete 
2       	Mon Aug 27 11:58:10 2018	SUPERSEDED	mychart-0.3.0	Upgrade complete 
3       	Mon Aug 27 12:06:26 2018	DELETED   	mychart-0.2.0	Deletion complete
```

有时候我们需要移除指定 Release 所有相关的 Kubernetes 资源和 Release 的历史记录，我们可以利用如下命令：

```bash
$ helm delete --purge helm-test
release "helm-test" deleted

$ helm history helm-test
Error: release: "helm-test" not found
```

