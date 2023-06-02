#/bin/bash

set -e

consul-k8s uninstall
kubectl delete ns consul

rm -f consul.json