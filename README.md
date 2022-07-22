# aws cognito backup buddy

[![Build and Publish docker](https://github.com/Loumaris/backupbuddy-cognito/actions/workflows/docker.yml/badge.svg)](https://github.com/Loumaris/backupbuddy-cognito/actions/workflows/docker.yml)
[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/repository/docker/loumaris/backupbuddy-cognito)


a small docker image which will export the userpool of cognito. Based on
[cognito-backup-restore](https://www.npmjs.com/package/cognito-backup-restore)

## setup

* clone this repository: `git clone https://github.com/Loumaris/backupbuddy.git`
* copy the `config/config.env.example` to `config/config.env`
* update the settings in `config/config.env`
  * only the `TEAMS_WEBHOOK_URL` is optional
* test the backup via:
  ```
  docker run -v ${PWD}/config:/backup/config -v ${PWD}/data:/backup/data loumaris/backupbuddy-cognito
  ```
* add the docker command to your cron daemon