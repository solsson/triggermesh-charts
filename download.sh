#!/bin/sh
# Copyright 2018 TriggerMesh, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


[ -z "$ISTIO_RELEASE" ] && ISTIO_RELEASE="1.0.2"
ISTIO_URL="https://github.com/istio/istio/releases/download/$ISTIO_RELEASE/istio-$ISTIO_RELEASE-linux.tar.gz"

#KNATIVE_RELEASE=latest
[ -z "$KNATIVE_RELEASE" ] && KNATIVE_RELEASE="previous/v0.2.1"
KNATIVE_BASE_URL="https://storage.googleapis.com/knative-releases/serving/$KNATIVE_RELEASE"

mkdir -p templates

# maybe we should parse https://storage.googleapis.com/knative-releases to find the files
for F in \
    build.yaml \
    istio-crds.yaml \
    istio-lean.yaml \
    istio.yaml \
    monitoring-lean.yaml \
    monitoring-logs-elasticsearch.yaml \
    monitoring-metrics-prometheus.yaml \
    monitoring-tracing-zipkin-in-mem.yaml \
    monitoring-tracing-zipkin.yaml \
    monitoring.yaml \
    serving.yaml; do
  curl -f -o "templates/$F" "$KNATIVE_BASE_URL/$F" \
    || echo "Maybe release $KNATIVE_RELEASE doesn't have file $F"
done

[ -f istio-$ISTIO_RELEASE.tgz ] || curl -o istio-$ISTIO_RELEASE.tgz -L "$ISTIO_URL"

rm -r istio-$ISTIO_RELEASE
tar xzf istio-1.0.2.tgz
