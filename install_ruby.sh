#!/bin/bash -eu

RUBY_VERSION=$1

PATH=${RBENV_ROOT}/bin:$PATH
eval "$(rbenv init -)"

rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
gem install bundler --no-rdoc --no-ri

