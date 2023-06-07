#/bin/bash

set -e

if [[ -z "${HCP_CLIENT_ID}" ]]; then
  echo "define HCP_CLIENT_ID environment variable"
  exit 1
fi

if [[ -z "${HCP_CLIENT_SECRET}" ]]; then
  echo "define HCP_CLIENT_SECRET environment variable"
  exit 1
fi

if [[ -z "${HCP_RESOURCE_ID}" ]]; then
  echo "define HCP_RESOURCE_ID environment variable"
  exit 1
fi

consul-k8s install -preset cloud \
   -hcp-resource-id ${HCP_RESOURCE_ID} \
   -set=global.peering.enabled=true \
   -set=global.image="consul:1.15.3" \
   -set=meshGateway.enabled=true \
   -set=ui.service.type=LoadBalancer

CONSUL_HTTP_ADDR="https://$(kubectl get service -n consul consul-ui -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
CONSUL_HTTP_TOKEN=$(kubectl get secrets -n consul consul-bootstrap-token -o=jsonpath='{.data.token}' | base64 -d)

cat <<EOF > consul.json
{
    "address": "${CONSUL_HTTP_ADDR}",
    "token": "${CONSUL_HTTP_TOKEN}"
}
EOF