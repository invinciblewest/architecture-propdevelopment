#!/usr/bin/env bash
set -euo pipefail

kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

kubectl create serviceaccount sa-platform-admin -n kube-system --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount sa-cluster-viewer -n kube-system --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount sa-cluster-operator -n kube-system --dry-run=client -o yaml | kubectl apply -f -

kubectl create serviceaccount sa-developer -n apps --dry-run=client -o yaml | kubectl apply -f -
