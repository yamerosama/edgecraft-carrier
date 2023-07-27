#!/bin/sh

set -eE

VERSION="0.5.5"
KUBECONFIG="../../88apps.kubeconfig"
NAMESPACE="kore-board"
NEXUS_CART_VALUES="./assets/kore-board/values.yaml"
CHART_NAME="kore-board"

# install using helm
## Usage:
##   helm upgrade [RELEASE] [CHART] [flags]
# helm upgrade kore-board kore/kore-board \
helm upgrade ${CHART_NAME} ./assets/kore-board \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${NEXUS_CART_VALUES} \
    --version ${VERSION}

# Sign-in Configuration
# How to get service-account-token
echo "Sign-in service account token:"
kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} get secret ${CHART_NAME}-secret -o jsonpath='{.data.token}' | base64 --decode
echo "\n"

# Get NodePort
echo "Service NodePort: $(kubectl --kubeconfig ${KUBECONFIG} -n ${NAMESPACE} get services frontend -o jsonpath='{.spec.ports[0].nodePort}')"