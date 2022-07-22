#!/bin/bash
set -e

echo "source env settings..."
source /backup/config/config.env

DATE=`date +"%Y-%m-%d-%H_%M"`

OUTPUT_DIRECTORY=${BACKUP_DIR}/${DATE}/

mkdir $OUTPUT_DIRECTORY

echo "dump user pool ${POOL} in region ${REGION}..."
cbr backup --aws-access-key $AWS_ACCESS_KEY_ID --aws-secret-key $AWS_SECRET_ACCESS_KEY -r $REGION  --pool $POOL --dir $OUTPUT_DIRECTORY

RESULT_BACKUP_DIR=$?

echo "clean up..."
find $BACKUP_DIR -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*.json" -exec rm -rf '{}' ';'

if [ -n "$TEAMS_WEBHOOK_URL" ]; then
  echo "ping MS Teams..."
  curl -s -H 'Content-Type: application/json' -d "{'text': 'Backup done for **$DB_NAME** on **$FILE**'}" $TEAMS_WEBHOOK_URL > /dev/null
fi

if [ -n "$UPTIME_ROBOT_URL" ]; then
  echo "ping uptime robot..."
  curl -s -H 'Content-Type: application/json' $UPTIME_ROBOT_URL > /dev/null
fi


if [ -n "$SEND_NOTIFICATION_EMAIL" ]; then

  if [ $RESULT_BACKUP_DIR -gt 0 ]
  then
    MAIL_SUBJECT_BACKUP_DIR="ERROR - backup cognito ${POOL}"
  else
    MAIL_SUBJECT_BACKUP_DIR="SUCCESS - backup cognito ${POOL}"
  fi

  mail \
          -a "From: ${MAIL_SENDER_INFO}"  \
          -s "$MAIL_SUBJECT_PG_DUMP" \
          "${MAIL_RECEIVER}" < $MAIL_SUBJECT_PG_DUMP

  mail \
          -a "From: ${MAIL_SENDER_INFO}"  \
          -s "$MAIL_SUBJECT_PG_DUMP" \
          "${MAIL_RECEIVER}" < $MAIL_SUBJECT_BACKUP_DIR

fi