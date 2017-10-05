FROM alpine
MAINTAINER Thomas Schwery <thomas@inf3.ch>

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
  && apk add --no-cache --virtual .fetch-deps \
        libmediainfo \
        ca-certificates \
        mono \
        curl

ENV SONARR_VERSION 2.0.0.4949

RUN curl -SL \
  http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${SONARR_VERSION}.mono.tar.gz \
  -o /tmp/NzbDrone.tgz \
  && tar xzvf /tmp/NzbDrone.tgz \
  && rm /tmp/NzbDrone.tgz

EXPOSE 8989 9898

VOLUME ["/config"]
VOLUME ["/downloads"]

ENV USERID 1000
ENV USERNAME sonarr
ENV USER_HOME /home/sonarr

RUN addgroup -g ${USERID} -S ${USERNAME} \
    && adduser -S -G ${USERNAME} -u ${USERID} -s /bin/sh -h ${USER_HOME} ${USERNAME}

USER sonarr

ADD start.sh /

ENTRYPOINT ["/start.sh"]
CMD ["mono", "/NzbDrone/NzbDrone.exe", "--no-browser", "-data=/config"]
