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

set -e

[ -z "$CLUSTER_DOMAIN" ] && CLUSTER_DOMAIN="example.com"
[ -z "$REGISTRY_HOST" ] && REGISTRY_HOST="knative.registry.svc.cluster.local"

tm deploy service test-fromimage --from-image=solsson/knative-test-image:build0 --wait

kubectl run -i -t knative-test-client --image=gcr.io/cloud-builders/curl --restart=Never --rm -- \
  -H "Host: test-fromimage.default.$CLUSTER_DOMAIN" \
  --connect-timeout 3 --retry 10 -vSL -w '\n' \
  -f http://knative-ingressgateway.istio-system.svc.cluster.local/

tm deploy buildtemplate --from-url https://raw.githubusercontent.com/triggermesh/openfaas-runtime/master/go/openfaas-go-runtime.yaml

mkdir testsource
cat <<EOF > testsource/hello.go
package main

import (
	"fmt"

	"github.com/golang/example/stringutil"
)

func main() {
	fmt.Println(stringutil.Reverse("!selpmaxe oG ,olleH"))
}
EOF

tm --registry-host "$REGISTRY_HOST" \
  deploy service test-localsource \
    --from-path testsource --build-argument DIRECTORY=. \
    --build-template openfaas-go-runtime \
    --wait

kubectl run -i -t knative-test-client --image=gcr.io/cloud-builders/curl --restart=Never --rm -- \
  -H "Host: test-localsource.default.$CLUSTER_DOMAIN" \
  -f http://knative-ingressgateway.istio-system.svc.cluster.local/

echo "All tests passeed"
