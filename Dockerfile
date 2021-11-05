FROM alpine:edge

RUN apk add --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
  tor haproxy ruby privoxy

RUN apk --update add --virtual build-dependencies g++ ruby-bigdecimal ruby-etc ruby-bundler ruby-dev  \
  && apk add ruby-nokogiri which \
  && gem install -N socksify \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/*

ADD haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb
ADD privoxy.cfg.erb /usr/local/etc/privoxy.cfg.erb

ADD start.rb /usr/local/bin/start.rb
RUN chmod +x /usr/local/bin/start.rb

EXPOSE 2090 8118 5566

CMD ruby /usr/local/bin/start.rb
