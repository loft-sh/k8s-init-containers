
# Kubernetes Init Containers

This is a complementary code repository to be used with [Loft Kubernetes Init Containers Blog Post](https://loft.sh/blog/kubernetes-init-containers/) and aims to explore motivation, features and, implementation of Kubernetes init containers.

Here we have an example application written in Go, which includes several init containers.

## Requirements

The project has several tool and infrastructure requirements.

### Tools

- DevSpace - ([Installation Documentation](https://devspace.sh/cli/docs/getting-started/installation))
- Kubectl - ([Installation Documentation](https://kubernetes.io/docs/tasks/tools/#kubectl))
- Helm - ([Installing Helm](https://helm.sh/docs/intro/install/))

>**_Note:_** If you are using [`asdf`](https://asdf-vm.com/) tool, then you only need to run `asdf install` in the working directory, `asdf` will install neccessary components.

### Infrastructure

- A Kubernetes cluster

If you don't have a cluster at hand, you can use Kind to create one.

- Kind ([Kind>User Guide>Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/))

## Setting Kubecontext and Namespace

```shell
devspace use context                  
devspace use namespace my-namespace 
```

For more information refer to [Kube-Context & Namespace](https://devspace.sh/cli/docs/getting-started/development#kube-context--namespace) section of DevSpace document.

## Deploying services

Let's run DevSpace in [Development Mode](https://devspace.sh/cli/docs/getting-started/development) via `devspace dev` command.

## Check out the logs of the init containers

`$ devspace logs -c init-fetch-files`

```shell
[info]   Printing logs of pod:container k8s-init-containers-74bb7788bb-5dmj6:init-fetch-files
/init-bin/fetchFiles.sh(1)20220221-01:58:12 : Started
/init-bin/fetchFiles.sh(1)20220221-01:58:12 : Files fetched successfuly.
/init-bin/fetchFiles.sh(1)20220221-01:58:12 : Ended
```

`$ devspace logs -c init-check-services`

```shell
[info]   Printing logs of pod:container k8s-init-containers-74bb7788bb-5dmj6:init-check-services
/init-bin/checkServices.sh(1)20220221-01:58:13 : Started
/init-bin/checkServices.sh(1)20220221-01:58:13 : Successfuly resolved (redis-master.default) in DNS.
/init-bin/checkServices.sh(1)20220221-01:58:13 : Successfuly resolved (postgresql.default) in DNS.
/init-bin/checkServices.sh(1)20220221-01:58:13 : Ended
```

`$ devspace logs -c init-check-database`

```shell
[info]   Printing logs of pod:container k8s-init-containers-74bb7788bb-5dmj6:init-check-database
/init-bin/checkDatabase.sh(1)20220221-01:58:14 : Started
/init-bin/checkDatabase.sh(1)20220221-01:58:14 : pg_isready says: postgresql.default.svc.cluster.local:5432 - no response
/init-bin/checkDatabase.sh(1)20220221-01:58:14 : Can't connect to (postgresql.default), database is not ready yet.
...
/init-bin/checkDatabase.sh(1)20220221-01:58:22 : pg_isready says: postgresql.default.svc.cluster.local:5432 - accepting connections
/init-bin/checkDatabase.sh(1)20220221-01:58:22 : Successfuly connected to (postgresql.default), database is ready.
/init-bin/checkDatabase.sh(1)20220221-01:58:22 : Ended
```

`$ devspace logs -c init-check-cache`

```shell
[info]   Printing logs of pod:container k8s-init-containers-74bb7788bb-5dmj6:init-check-cache
/init-bin/checkCache.sh(1)20220221-01:58:22 : Started
Could not connect to Redis at redis-master.default.svc.cluster.local:6379: Connection refused
/init-bin/checkCache.sh(1)20220221-01:58:22 : redis-cli says: 
/init-bin/checkCache.sh(1)20220221-01:58:22 : Can't connect to (redis-master.default), cache is not ready yet.
Could not connect to Redis at redis-master.default.svc.cluster.local:6379: Connection refused
/init-bin/checkCache.sh(1)20220221-01:58:23 : redis-cli says: 
/init-bin/checkCache.sh(1)20220221-01:58:23 : Can't connect to (redis-master.default), cache is not ready yet.
Could not connect to Redis at redis-master.default.svc.cluster.local:6379: Connection refused
/init-bin/checkCache.sh(1)20220221-01:58:24 : redis-cli says: 
/init-bin/checkCache.sh(1)20220221-01:58:24 : Can't connect to (redis-master.default), cache is not ready yet.
Could not connect to Redis at redis-master.default.svc.cluster.local:6379: Connection refused
/init-bin/checkCache.sh(1)20220221-01:58:25 : redis-cli says: 
/init-bin/checkCache.sh(1)20220221-01:58:25 : Can't connect to (redis-master.default), cache is not ready yet.
Could not connect to Redis at redis-master.default.svc.cluster.local:6379: Connection refused
/init-bin/checkCache.sh(1)20220221-01:58:26 : redis-cli says: 
/init-bin/checkCache.sh(1)20220221-01:58:26 : Can't connect to (redis-master.default), cache is not ready yet.
Could not connect to Redis at redis-master.default.svc.cluster.local:6379: Connection refused
/init-bin/checkCache.sh(1)20220221-01:58:27 : redis-cli says: 
/init-bin/checkCache.sh(1)20220221-01:58:27 : Can't connect to (redis-master.default), cache is not ready yet.
/init-bin/checkCache.sh(1)20220221-01:58:28 : redis-cli says: PONG
/init-bin/checkCache.sh(1)20220221-01:58:28 : Successfuly connected to (redis-master.default), cache is ready.
/init-bin/checkCache.sh(1)20220221-01:58:28 : Ended
```

## Clean Up

You can clean all resources we used via `devspace purge` command when you are in the project directory.

`$ devspace purge`

```shell
[info]   Using namespace 'default'
[info]   Using kube context 'kind-kind'
[info]   Execute '/home/logut/.devspace/bin/helm delete postgresql --namespace default --kube-context kind-kind'
[done] √ Successfully deleted deployment postgresql
[info]   Execute '/home/logut/.devspace/bin/helm delete redis --namespace default --kube-context kind-kind'
[done] √ Successfully deleted deployment redis
[info]   Execute '/home/logut/.devspace/bin/helm delete k8s-init-containers --namespace default --kube-context kind-kind'
[done] √ Successfully deleted deployment k8s-init-containers
```
