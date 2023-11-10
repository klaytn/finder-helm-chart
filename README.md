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

| parameter                        | value                                                                                              |
| -------------------------------- | -------------------------------------------------------------------------------------------------- |
| global.nameOverride              | override defulat name `finder`                                                                     |
| global.network                   | `baobab` or `cypress`                                                                              |
| global.profile                   | `stag`, `prod`                                                                                     |
| global.namespace                 | create service aacount with the namespace                                                          |
| global.serviceAccountEmail       | service account role arn created                                                                   |
| secretManager.REGION             | aws secret manager regsion                                                                         |
| secretManager.ARN                | aws secret manager ARN `arn:aws:secretsmanager:${region}:${identity-number}:secret:${secret name}` |
| s3.AWS_S3_REGION                 | AWS S3 region                                                                                      |
| s3.AWS_S3_PRIVATE_BUCKET         | AWS S3 private bucket name                                                                         |
| s3.AWS_S3_PUBLIC_BUCKET          | AWS S3 public bucket name                                                                          |
| cdn.URL                          | CDN service URL                                                                                    |
| chain.CAVER_CYPRESS_RPC_ENDPOINT | Klaytn Cypress RPC endpoint                                                                        |
| chain.CAVER_BAOBAB_RPC_ENDPOINT  | Klaytn Baobab RPC endpoint                                                                         |
| datbaseEndpoint                  | Database End Point                                                                                 |
| openSearch.OPEN_SEARCH_URL       | elastic open search url                                                                            |
| redis.REDIS_ENDPOINT             | redis endpoint                                                                                     |
| apiEndpint                       | this endpoint should match host of api                                                             |

## SPRING_PROFILES_ACTIVE

Each service has an environment parameter `SPRING_PROFILES_ACTIVE`. Changing this parameter changes the services that are run, so please refer to the table below and fill it out.

| serivce  | profile | network | value                          |
| -------- | ------- | ------- | ------------------------------ |
| api      | prod    | baobab  | `prodBaobab,api`               |
| api      | prod    | cypress | `prodCypress,api`              |
| api      | stage   | baobab  | `stagBaobab,all,devAuthToken`  |
| api      | stage   | cypress | `stagCypress,all,devAuthToken` |
| oapi     | prod    | baobab  | `prodBaobab`                   |
| oapi     | prod    | cypress | `prodCypress`                  |
| oapi     | stage   | baobab  | `stagBaobab`                   |
| oapi     | stage   | cypress | `stagCypress`                  |
| papi     | prod    | baobab  | `prodBaobab,papi`              |
| papi     | prod    | cypress | `prodCypress,papi`             |
| worker   |         |         | `prod`                         |
| compiler |         |         | `prod`                         |

## Exmaple for Values.yaml

create my-values.yaml file

```yaml
global:
  nameOverride: finder
  network: baobab
  profile: prod
  namespace: finder
  serviceAccountName: sa-finder-service
  serviceAccountEmail: arn:aws:iam:************:role/klaytn_cluster_prod-finder-****

api:
  front:
    ingress: #alb.ingress.kubernetes.io/group.name
    images:
      repository: public.ecr.aws/y1e5c4k9/finder-api
      tag: public-3b7017c3c578da343833d6d6d7a070517e700fbb
    host: test-prod-baobab-api.klaytnfinder.io
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
      repository: public.ecr.aws/y1e5c4k9/finder-api
      tag: public-3b7017c3c578da343833d6d6d7a070517e700fbb
    host: test-prod-baobab-papi.klaytnfinder.io
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
      repository: public.ecr.aws/y1e5c4k9/finder-oapi
      tag: public-06-d873c1e4b5760469a43918edd22ea17336b36db8
    host: test-prod-baobab-oapi.klaytnfinder.io
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
    repository: public.ecr.aws/y1e5c4k9/finder-worker
    tag: public-3b7017c3c578da343833d6d6d7a070517e700fbb
  host: test-worker-api.klaytnfinder.io
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
    repository: public.ecr.aws/y1e5c4k9/finder-worker
    tag: public-3b7017c3c578da343833d6d6d7a070517e700fbb
  host: test-worker-api.klaytnfinder.io
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
