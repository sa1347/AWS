#!/bin/bash

BUILD_JAR=$(ls /home/ec2-user/jenkins/build/libs/*.jar)
JAR_NAME=$(basename $BUILD_JAR)
echo ">>> build 파일명: $JAR_NAME" >> /home/ec2-user/deploy.log

echo ">>> build 파일 복사" >> /home/ec2-user/deploy.log
DEPLOY_PATH=/home/ec2-user/
cp $BUILD_JAR $DEPLOY_PATH

echo ">>> 현재 실행중인 애플리케이션 pid 확인 후 일괄 종료" >> /home/ec2-user/deploy.log
sudo ps -ef | grep java | awk '{print $2}' | xargs kill -15

DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo ">>> DEPLOY_JAR 배포"    >> /home/ec2-user/deploy.log
nohup java -jar $DEPLOY_JAR >> /home/ec2-user/deploy.log 2>/home/ec2-user/deploy_err.log &
# 터미널 세션이 끊겨도 프로세스가 종료되지 않게 함
