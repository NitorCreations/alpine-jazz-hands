
FROM gliderlabs/alpine:3.2
RUN apk -U add alpine-sdk coreutils \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/sh -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && rm -rf /var/cache/apk/*
ADD entrypoint.sh /bin/
ADD abuild.conf /etc/abuild.conf
USER builder
ENTRYPOINT entrypoint.sh
WORKDIR /home/builder/package
ENV PACKAGER_PRIVKEY /home/builder/abuild.rsa
