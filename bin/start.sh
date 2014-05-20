#!/bin/bash

ROOT_DIR=$(dirname $(readlink -f $0) | sed 's/\/bin$//')
source ${ROOT_DIR}/master/.bashrc
TIMEOUT=60
PORT=8081
JENKINS_LOG="${ROOT_DIR}/master/log/jenkins.log"
## clearing out jenkins-master.log each time
echo "Cleaning log out before we start"
if [ ! -d ${ROOT_DIR}/master/log ];
then
   mkdir -p ${ROOT_DIR}/master/log
else 
   rm -f ${JENKINS_LOG}
fi
echo "Starting jenkins"
java -jar ${ROOT_DIR}/master/jenkins.war --httpPort=${PORT} > ${JENKINS_LOG} 2>&1 &
while true
do
   sleep 5
   TIME=$(expr ${TIME} + 5)
   if [ $(grep -c 'INFO: Jenkins is fully up and running' ${JENKINS_LOG}) -gt 0 ];
   then
      echo "Jenkins fully up"
      exit 0
   fi
   if [ ${TIME} -ge ${TIMEOUT} ]
   then
      echo "Timeout of ${TIMEOUT} exceed.  Outputing last 50 lines of ${JENKINS_LOG}"
      tail -50 ${JENKINS_LOG}
      exit 2
   fi
done

