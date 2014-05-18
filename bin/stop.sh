#!/bin/bash
TIMEOUT=60
PORT=8081
## stop
java -jar master/jenkins/jenkins-cli.jar -s http://localhost:${PORT} shutdown >/dev/null 2>&1

while true
do
   sleep 5
   TIME=$(expr ${TIME} + 5)
   if [ $(ps auxww | grep jenkins | grep -v grep | wc -l) -eq 0 ];
   then
      echo "Jenkins down"
      exit 0
   fi
   if [ ${TIME} -ge ${TIMEOUT} ]
   then
      echo "Timeout of ${TIMEOUT} exceed.  Killing forcefully."  
      kill -9 $(ps auxww | grep jenkins | grep -v grep | awk '{print $2}')
      exit 2
   fi   
done
