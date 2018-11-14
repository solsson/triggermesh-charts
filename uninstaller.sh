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


source ./download.sh

# TODO preserve service name: knative-ingressgateway namespace: istio-system

for F in \
    monitoring.yaml \
    build.yaml \
    serving.yaml \
    istio.yaml \
    istio-crds.yaml; do
  kubectl delete --ignore-not-found=true -f "templates/$F"
done

kubectl delete --ignore-not-found=true -f istio-$ISTIO_RELEASE/install/kubernetes/helm/istio/templates/crds.yaml
kubectl delete --ignore-not-found=true -f istio-$ISTIO_RELEASE/install/kubernetes/istio-demo.yaml
