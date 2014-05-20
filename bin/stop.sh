#!/bin/bash

ROOT_DIR=$(dirname $(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)  | sed 's/\/bin$//')

source ${ROOT_DIR}/master/.bashrc
TIMEOUT=60
## stop
if [ -e ${ROOT_DIR}/master/jenkins-cli.jar ];
then
   java -jar ${ROOT_DIR}/master/jenkins-cli.jar -s http://localhost:${JENKINS_PORT} shutdown >/dev/null 2>&1
else
   ## dont bother with timeout if theres no cli yet
   TIME=${TIMEOUT}
fi

while true
do
   sleep 5
   TIME=$(expr ${TIME} + 5)
   if [ $(ps auxww | grep java | grep 'jenkins.war' | grep -v grep | wc -l) -eq 0 ];
   then
      echo "Jenkins down"
      exit 0
   fi
   if [ ${TIME} -ge ${TIMEOUT} ]
   then
      echo "Timeout of ${TIMEOUT} exceed.  Killing forcefully."  
      kill -9 $(ps auxww | grep java | grep 'jenkins.war' | grep -v grep | awk '{print $2}')
      exit 2
   fi   
done
