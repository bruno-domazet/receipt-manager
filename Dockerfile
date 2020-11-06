FROM ubuntu:18.04

ENV NODE_VERSION="v14.15.0"
ENV YARN_VERSION="v1.22.5"
ENV WEB_PORT="8080"

# OCR lib
RUN apt-get update -qq && apt-get install -qq \
    curl \
    tesseract-ocr \
    tesseract-ocr-dan \
    tesseract-ocr-eng \
    && rm -rf /var/cache/apt/lists

# INSTALL NODE && YARN
RUN echo "${NODE_VERSION}" 
RUN	mkdir /opt/nodejs &&\
    curl -OLSs https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz &&\
    tar xzf node-${NODE_VERSION}-linux-x64.tar.gz -C /opt/nodejs &&\
    ln -s /opt/nodejs/node-${NODE_VERSION}-linux-x64 /opt/nodejs/current &&\
    ln -s /opt/nodejs/current/bin/node /bin/node &&\
    rm node-${NODE_VERSION}-linux-x64.tar.gz &&\
    echo "... node $(node -v)"

RUN echo "${YARN_VERSION}" 
RUN mkdir /opt/yarn &&\
    curl -OLSs https://github.com/yarnpkg/yarn/releases/download/${YARN_VERSION}/yarn-${YARN_VERSION}.tar.gz &&\
    tar xzf yarn-${YARN_VERSION}.tar.gz -C /opt/yarn &&\
    ln -s /opt/yarn/yarn-${YARN_VERSION} /opt/yarn/current &&\
    ln -s /opt/yarn/current/bin/yarn /bin/yarn &&\
    rm yarn-${YARN_VERSION}.tar.gz &&\
    echo "... yarn $(yarn -v)\n cache $(yarn cache dir)"

WORKDIR /usr/src/app

COPY . .

RUN yarn install && yarn build

EXPOSE ${WEB_PORT}

CMD [ "node", "dist/index.js" ]