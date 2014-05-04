#!/bin/bash
## download the cli
pushd jenkins
curl -s -L -O http://localhost:8080/jnlpJars/jenkins-cli.jar
## install plugins
## order matters with installation due to dependencies
PLUGINS="github-api github git-client scm-api git ghprb greenballs token-macro email-ext postbuildscript dashboard-view"

for PLUGIN in ${PLUGINS}
do
   echo "Installing plugin ${PLUGIN}"
   java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin ${PLUGIN}.hpi
done

echo "Copying over master config.xml"
cp ../../cfg/master/config.xml config.xml
cp ../../cfg/master/credentials.xml credentials.xml

echo "Installing slave"
java -jar jenkins-cli.jar -s http://localhost:8080 create-node slave < ../../cfg/slave/node.xml

echo "Restarting Jenkins"
java -jar jenkins-cli.jar -s http://localhost:8080 restart

echo "Sleeping 30s"
sleep 30
popd
echo "Installing jobs"
pushd ../jobs
for JOB in $(ls *.xml)
do
   echo "Installing job ${JOB}"
   NAME=$(echo ${JOB} | awk -F'.xml' '{print $1}')
   java -jar ../master/jenkins/jenkins-cli.jar -s http://localhost:8080 create-job ${NAME} < ${JOB}
done
popd
