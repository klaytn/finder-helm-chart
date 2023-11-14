# Klaytn Finder Helm Charts

[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/klaytn)](hhttps://klaytn.foundation/)

This repository is for the helm charts of the Klaytn Finder Backend.
For the overall architecture of the finder, please refer to the [Main Repo](https://github.com/klaytn/finder/blob/main/README.md).

The code is provided as-is with no warranties.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add klaytn-finder https://klaytn.github.io/finder-helm-chart/
```

create namepsace finder

```console
kubectl create namespace finder
```

| parameter                 | value                                     |
| ------------------------- | ----------------------------------------- |
| global.nameOverride       | override default name `finder`            |
| global.network            | `baobab` or `cypress`                     |
| global.profile            | `stag`, `prod`                            |
| global.projectId          | google project id                         |
| global.namespace          | create service aacount with the namespace |
| global.domain             | domain name                               |
| global.serviceAccountName | service account name                      |

## SPRING_PROFILES_ACTIVE

Each service has an environment parameter `SPRING_PROFILES_ACTIVE`. Changing this parameter changes the services that are run, so please refer to the table below and fill it out.

| service  | profile | network | value                               |
| -------- | ------- | ------- | ----------------------------------- |
| api      | prod    | baobab  | `prod,prodBaobab,api`               |
| api      | prod    | cypress | `prod,prodCypress,api`              |
| api      | stage   | baobab  | `stag,stagBaobab,all,devAuthToken`  |
| api      | stage   | cypress | `stag,stagCypress,all,devAuthToken` |
| oapi     | prod    | baobab  | `prod,prodBaobab`                   |
| oapi     | prod    | cypress | `prod,prodCypress`                  |
| oapi     | stage   | baobab  | `stag,stagBaobab`                   |
| oapi     | stage   | cypress | `stag,stagCypress`                  |
| papi     | prod    | baobab  | `prod,prodBaobab,papi`              |
| papi     | prod    | cypress | `prod,prodCypress,papi`             |
| worker   |         |         | `prod`                              |
| compiler |         |         | `prod`                              |

## Exmaple for Values.yaml

create my-values.yaml file

```yaml
global:
  nameOverride: finder
  network: baobab
  profile: prod
  namespace: finder
  projectId: klaytn-finder
  domain: klaytnfinder.io
  serviceAccountName: sa-finder-service

api:
  front:
    images:
      repository: asia-northeast3-docker.pkg.dev/klaytn-finder/finder-prod/finder-api
      tag: public-4727becfbff481b98b3cb0c77fd0753368ad2d22
    replicas: 1
    env:
      - name: SPRING_PROFILES_ACTIVE
        value: prodBaobab,api
    resources:
      requests:
        cpu: 1000m
        memory: 2Gi
      limits:
        cpu: 1000m
        memory: 2Gi
  papi:
    images:
      ingress: #alb.ingress.kubernetes.io/group.name
      repository: asia-northeast3-docker.pkg.dev/klaytn-finder/finder-prod/finder-api
      tag: public-4727becfbff481b98b3cb0c77fd0753368ad2d22
    replicas: 1
    env:
      - name: SPRING_PROFILES_ACTIVE
        value: prodBaobab,papi
    resources:
      requests:
        cpu: 1000m
        memory: 2Gi
      limits:
        cpu: 1000m
        memory: 2Gi
  oapi:
    ingress: #alb.ingress.kubernetes.io/group.name
    images:
      repository: asia-northeast3-docker.pkg.dev/klaytn-finder/finder-prod/finder-oapi
      tag: public-06-d873c1e4b5760469a43918edd22ea17336b36db8
    replicas: 1
    env:
      - name: SPRING_PROFILES_ACTIVE
        value: prodBaobab
    resources:
      requests:
        cpu: 2000m
        memory: 2Gi
      limits:
        cpu: 2000m
        memory: 2Gi
worker:
  ingress: #alb.ingress.kubernetes.io/group.name
  images:
    repository: asia-northeast3-docker.pkg.dev/klaytn-finder/finder-prod/finder-worker
    tag: public-4727becfbff481b98b3cb0c77fd0753368ad2d22
  replicas: 1
  env:
    - name: SPRING_PROFILES_ACTIVE
      value: prod
  resources:
    requests:
      cpu: 1000m
      memory: 2Gi
    limits:
      cpu: 1000m
      memory: 2Gi

compiler:
  ingress: #alb.ingress.kubernetes.io/group.name
  images:
    repository: asia-northeast3-docker.pkg.dev/klaytn-finder/finder-prod/finder-worker
    tag: public-4727becfbff481b98b3cb0c77fd0753368ad2d22
  replicas: 1
  env:
    - name: SPRING_PROFILES_ACTIVE
      value: prod
  resources:
    requests:
      cpu: 1000m
      memory: 2Gi
    limits:
      cpu: 1000m
      memory: 2Gi
```

Installing with my-values.yaml file

```bash
helm install finder -n finder klaytn-finder/finder --values my-values.yaml
```

### <a name="help"></a>Getting Help

Your feedback is always welcome!
