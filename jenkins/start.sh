source .bashrc
TIMEOUT=60
## clearing out jenkins log each time
rm -f jenkins.log
java -jar jenkins/jenkins.war > jenkins.log 2>&1 &
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

