#!/bin/bash
rm -f ./clusters/*.yaml
source ./cluster-template-openstack.rc

FILE_NAME="single-mk8s-provisioning"
COUNT=0
CT=0

## 생성 수 지정
if [[ "$1" -gt 0 ]]; then
    CT=$1
else
    CT=1
fi

while [ "$COUNT" -lt $CT ]
do
COUNT=$(($COUNT + 1))
clusterctl --kubeconfig=./kubeconfig generate cluster $FILE_NAME-$COUNT --target-namespace=default --from ./cluster-template-openstack.yaml > ./clusters/$FILE_NAME-$COUNT.yaml
done