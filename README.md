# Chart for Knative

It installs the released manifest for knative, including Istio as [documented](https://github.com/knative/docs/blob/master/install/Knative-with-any-k8s.md)

## Setup the Chart repo

```
helm repo add tm gs://triggermesh-charts
```

## Search for knative and install

```
helm search knative
helm install --debug --dry-run tm/knative
```

If you are sure you want to do the install:

```
helm install tm/knative
```

## Building

This chart is built via Google Cloud build, check `cloudbuild.yaml`

