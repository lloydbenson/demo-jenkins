#!/bin/bash
## download the cli
pushd jenkins
curl -s -L -O http://localhost:8080/jnlpJars/jenkins-cli.jar
## install plugins
## order matters with installation due to dependencies
PLUGINS="github-api git-client scm-api git ghprb greenballs token-macro email-ext postbuildscript dashboard-view"

for PLUGIN in ${PLUGINS}
do
   echo "Installing plugin ${PLUGIN}"
   java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin ${PLUGIN}.hpi
done

echo "Restarting Jenkins"
java -jar jenkins-cli.jar -s http://localhost:8080 restart

sleep 30

echo "Installing jobs"
popd
pushd jobs
for JOB in $(ls *.xml)
do
   echo "Installing job ${JOB}"
   NAME=$(echo ${JOB} | awk -F'.xml' '{print $1}')
   java -jar ../jenkins/jenkins-cli.jar -s http://localhost:8080 create-job ${NAME} < ${JOB}
done
