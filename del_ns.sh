#!/bin/bash



token=$(kubectl get namespace qa -o=jsonpath='{.metadata.resourceVersion}')

helm uninstall aws-load-balancer-controller -n kube-system
kubectl delete namespace qa
pkill -SIGINT -f $0
curl -k -H "Content-Type: application/json" -X PUT --data '{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"qa","resourceVersion":"'$token'"},"spec":{"finalizers":[]}}' http://localhost:8001/api/v1/namespaces/qa/finalize
