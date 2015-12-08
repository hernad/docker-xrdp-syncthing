FROM hernad/neutrino-xrdp

MAINTAINER Ernad Husremovic hernad@bring.out.ba

ENV SYNCTHING_USER syncthing
ENV UID 22000

RUN apt-get update -y && apt-get install -y supervisor

RUN useradd --no-create-home -g users --uid $UID $SYNCTHING_USER

ENV SYNCTHING_VER 0.12.7
# https://github.com/syncthing/syncthing/releases/download/v0.12.7/syncthing-linux-amd64-v0.12.7.tar.gz
RUN cd /tmp && curl -LO https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VER}/syncthing-linux-amd64-v${SYNCTHING_VER}.tar.gz &&\
  ls -lh syncthing*.tar.gz && \
  tar -xvzf syncthing-linux-amd64-v${SYNCTHING_VER}.tar.gz && \
  mkdir -p /home/${SYNCTHING_USER}/bin && mv syncthing-linux-amd64-v$SYNCTHING_VER/syncthing /home/$SYNCTHING_USER/bin && \
  mkdir -p /home/${SYNCTHING_USER}/syncthing/config  &&\
  chown ${SYNCTHING_USER}.users -R /home/$SYNCTHING_USER && \
  rm -rf syncthing-linux-*.tar.gz syncthing-linux-*
  

RUN echo "[supervisord]" > /etc/supervisord.conf &&\
    echo "nodaemon=true" >> /etc/supervisord.conf

#    echo "[program:xrdp]" >> /etc/supervisord.conf &&\
#    echo "command=/etc/init.d/xrdp.sh start" >> /etc/supervisord.conf &&\
#    echo "user=root" >> /etc/supervisord.conf &&\
#    echo "directory=/root" >> /etc/supervisord.conf

RUN echo "[program:syncthing]" >> /etc/supervisord.conf && \
    echo "command=/home/$SYNCTHING_USER/bin/syncthing -no-browser -home=\"/home/$SYNCTHING_USER/syncthing/config"" >> /etc/supervisord.conf && \
    echo "directory=/home/$SYNCTHING_USER" >> /etc/supervisord.conf && \
    echo "autorestart=True" >> /etc/supervisord.conf && \
    echo "user=$SYNCTHING_USER" >> /etc/supervisord.conf && \
    echo "environment=STNORESTART=\"1\", HOME=\"/home/$SYNCTHING_USER\"" >> /etc/supervisord.conf

ADD start.sh /

EXPOSE 3389
EXPOSE 8384

CMD ["bash", "-c", "/etc/init.d/xrdp.sh start ; /start.sh ; /usr/bin/supervisord"]
