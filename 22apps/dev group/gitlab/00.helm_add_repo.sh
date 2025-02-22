#!/bin/sh

# add gitlab repo
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# download charts
helm pull --untar -d ./assets gitlab/gitlab