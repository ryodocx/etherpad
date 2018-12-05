FROM node:11.3-alpine

WORKDIR /opt/etherpad
ENV VERSION=1.7.0

RUN set -x \
  && apk --virtual build-dependencies add git curl \
  && git clone --depth=1 -b ${VERSION} https://github.com/ether/etherpad-lite.git /opt/etherpad \
  && git checkout -b ${VERSION} \
  && /opt/etherpad/bin/installDeps.sh \
  && mv /opt/etherpad/settings.json.template /opt/etherpad/settings.json \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/*

COPY additional_package.json /opt/etherpad/package.json
RUN set -x \
  && cd /opt/etherpad \
  && rm -rf node_modules \
  && npm install --no-save --loglevel warn \
  && cd /opt/etherpad/node_modules \
  && ln -s ../src ep_etherpad-lite

EXPOSE 9001
ENV NODE_ENV=production
ENV SCRIPTPATH=/opt/etherpad

CMD ["node", "/opt/etherpad/node_modules/ep_etherpad-lite/node/server.js"]
