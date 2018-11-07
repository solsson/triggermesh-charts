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

kubectl label namespace default istio-injection=enabled

[ ! -z "$USE_OFFICIAL_ISTIO" ] && {
  kubectl apply -f istio-$ISTIO_RELEASE/install/kubernetes/helm/istio/templates/crds.yaml
  read -p "Press enter to continue"
  kubectl apply -f istio-$ISTIO_RELEASE/install/kubernetes/istio-demo.yaml
  read -p "Press enter to continue"
}

kubectl create -f templates/istio-crds.yaml
read -p "Press enter to continue"
kubectl create -f templates/istio.yaml
read -p "Press enter to continue"

kubectl apply -f templates/serving.yaml
kubectl apply -f templates/build.yaml
read -p "Press enter to continue"

kubectl apply -f templates/monitoring.yaml
