source jenkins/.bashrc
TIMEOUT=60
PORT=8081
## clearing out jenkins-master.log each time
echo "Cleaning log out before we start"
rm -f jenkins.log
echo "Starting jenkins"
java -jar jenkins/jenkins.war --httpPort=${PORT} > jenkins.log 2>&1 &
while true
do
   sleep 5
   TIME=$(expr ${TIME} + 5)
   if [ $(grep -c 'INFO: Jenkins is fully up and running' jenkins.log) -gt 0 ];
   then
      echo "Jenkins fully up"
      exit 0
   fi
   if [ ${TIME} -ge ${TIMEOUT} ]
   then
      echo "Timeout of ${TIMEOUT} exceed.  Outputing last 50 lines of jenkins.log"
      tail -50 jenkins.log
      exit 2
   fi
done

