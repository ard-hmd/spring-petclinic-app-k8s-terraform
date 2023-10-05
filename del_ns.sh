#!/bin/bash

helm uninstall aws-load-balancer-controller -n kube-system && \
kubectl proxy &
TOKEN="$(kubectl get namespace qa -o=jsonpath='{.metadata.resourceVersion}')"
curl -k -H "Content-Type: application/json" -X PUT --data '{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"qa","resourceVersion":"'$TOKEN'"},"spec":{"finalizers":[]}}' http://localhost:8001/api/v1/namespaces/qa/finalize

exit 0
