FROM neutrino-xrdp
#FROM hernad/neutrino-xrdp

MAINTAINER Ernad Husremovic hernad@bring.out.ba

ENV SYNCTHING_USER dockerx

RUN apt-get update -y && apt-get install -y supervisor

ENV SYNCTHING_VER 0.13.7
# https://github.com/syncthing/syncthing/releases/download/v0.12.7/syncthing-linux-amd64-v0.12.7.tar.gz
RUN cd /tmp && curl -LO https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VER}/syncthing-linux-amd64-v${SYNCTHING_VER}.tar.gz &&\
  ls -lh syncthing*.tar.gz && \
  tar -xvzf syncthing-linux-amd64-v${SYNCTHING_VER}.tar.gz && \
  mkdir -p /syncthing/bin && mv syncthing-linux-amd64-v$SYNCTHING_VER/syncthing /syncthing/bin && \
  mkdir -p /syncthing/config  &&\
  mkdir -p /syncthing/data  &&\
  chown ${SYNCTHING_USER}.users -R /syncthing && \
  rm -rf syncthing-linux-*.tar.gz syncthing-linux-*
  

ENV SUPER_F  /etc/supervisord.conf

RUN echo "[supervisord]" > $SUPER_F &&\
    echo "nodaemon=true" >> $SUPER_F

RUN echo "[program:syncthing]" >> $SUPER_F && \
    echo "command=/syncthing/bin/syncthing -no-browser -home=\"/syncthing/config\"" >> $SUPER_F && \
    echo "directory=/syncthing" >> $SUPER_F && \
    echo "autorestart=True" >> $SUPER_F && \
    echo "user=$SYNCTHING_USER" >> $SUPER_F && \
    echo "environment=STNORESTART=\"1\", HOME=\"/syncthing\"" >> $SUPER_F &&\
    echo "[program:xrdp]" >> $SUPER_F &&\
    echo "priority=10" >> $SUPER_F &&\
    echo "directory=/" >> $SUPER_F &&\
    echo "command=/etc/init.d/xrdp.sh start" >> $SUPER_F &&\
    echo "user=root" >> $SUPER_F &&\
    echo "autostart=true" >> $SUPER_F && \
    echo "autorestart=true" >> $SUPER_F && \
    echo "stopsignal=QUIT" >> $SUPER_F && \
    echo "redirect_stderr=true" >> $SUPER_F


ADD start.sh /

EXPOSE 3389
EXPOSE 8080

#ADD xrdp.ini /etc/xrdp/
#ADD .xinitrc /home/dockerx/
CMD ["bash", "-c", "/etc/init.d/dbus start ; /start.sh ; /usr/bin/supervisord"]
