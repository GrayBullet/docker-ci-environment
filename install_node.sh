#!/bin/bash

NODE_VERSION=$1

. $NVM_DIR/nvm.sh

nvm install $NODE_VERSION
nvm exec $NODE_VERSION npm install -g grunt-cli gulp-cli bower
nvm alias default $NODE_VERSION

