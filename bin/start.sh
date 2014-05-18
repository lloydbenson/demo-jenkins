source master/jenkins/.bashrc
TIMEOUT=60
PORT=8081
JENKINS_LOG="master/jenkins/log/jenkins.log"
## clearing out jenkins-master.log each time
echo "Cleaning log out before we start"
if [ ! -d master/jenkins/log ];
then
   mkdir -p master/jenkins/log
else 
   rm -f ${JENKINS_LOG}
fi
echo "Starting jenkins"
java -jar master/jenkins/jenkins.war --httpPort=${PORT} > ${JENKINS_LOG} 2>&1 &
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

