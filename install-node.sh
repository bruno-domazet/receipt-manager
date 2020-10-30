#!/bin/bash
export NODE_VERSION=v14.15.0
export YARN_VERSION=v1.22.5

# INSTALL NODE && YARN
sudo mkdir -p /opt/nodejs &&\
    curl -OLSs https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz &&\
    sudo tar xzf node-${NODE_VERSION}-linux-x64.tar.gz -C /opt/nodejs &&\
    sudo ln -s /opt/nodejs/node-${NODE_VERSION}-linux-x64 /opt/nodejs/current &&\
    sudo ln -s /opt/nodejs/current/bin/node /bin/node &&\
    rm -f node-${NODE_VERSION}-linux-x64.tar.gz &&\
    echo "... node: $(node -v)"

sudo mkdir -p /opt/yarn &&\
    curl -OLSs https://github.com/yarnpkg/yarn/releases/download/${YARN_VERSION}/yarn-${YARN_VERSION}.tar.gz &&\
    sudo tar xzf yarn-${YARN_VERSION}.tar.gz -C /opt/yarn &&\
    sudo ln -s /opt/yarn/yarn-${YARN_VERSION} /opt/yarn/current &&\
    sudo ln -s /opt/yarn/current/bin/yarn /bin/yarn &&\
    rm -f yarn-${YARN_VERSION}.tar.gz &&\
    echo "... yarn: $(yarn -v)"
    echo "... cache: $(yarn cache dir)"