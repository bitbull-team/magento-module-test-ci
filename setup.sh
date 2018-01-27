#!/usr/bin/env bash

BUILDENV=`mktemp -d /tmp/test_environment.XXXXXXXX`

git clone https://github.com/bitbull-team/magento-module-test-ci.git $BUILDENV

cd $BUILDENV

./install.sh