FROM centos:7
MAINTAINER Thomas Schwery <thomas@inf3.ch>

RUN \
  yum install -y epel-release yum-utils \
  && rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" \
  && yum-config-manager --add-repo http://download.mono-project.com/repo/centos/ \
  && yum install -y wget mediainfo libzen libmediainfo curl gettext mono-core mono-devel sqlite.x86_64 \
  && yum clean all \
  && rm -rf /var/cache/yum || true

RUN \
  curl -SL https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 -o /usr/bin/dumb-init \
  && chmod +x /usr/bin/dumb-init

ENV YDG_CONFIG_HOME=/config
ENV SONARR_VERSION 2.0.0.5054

RUN \
  curl -SL http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${SONARR_VERSION}.mono.tar.gz -o /tmp/NzbDrone.tgz \
  && tar xzvf /tmp/NzbDrone.tgz \
  && rm /tmp/NzbDrone.tgz

EXPOSE 8989 9898

VOLUME ["/config", "/data"]

ENV USERID 1000
ENV USERNAME sonarr

RUN useradd ${USERNAME} -u ${USERID}
USER sonarr

CMD ["/usr/bin/dumb-init", "/usr/bin/mono", "/NzbDrone/NzbDrone.exe", "--no-browser", "-data=/config"]
