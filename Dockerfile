FROM node:12

WORKDIR /backup

VOLUME /backup/data

VOLUME /backup/config

RUN npm install -g cognito-backup-restore

ADD bin/run.sh /backup/run.sh

RUN chmod a+x /backup/run.sh

CMD ["/backup/run.sh"]
