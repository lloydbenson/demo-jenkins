#!/bin/bash

pushd jenkins
## download the cli
curl -s -L -O http://localhost:8080/jnlpJars/jenkins-cli.jar
## install plugins
## order matters with installation due to dependencies
PLUGINS="github-api github git-client scm-api git ghprb greenballs token-macro email-ext postbuildscript dashboard-view nodejs"

for PLUGIN in ${PLUGINS}
do
   echo "Installing plugin ${PLUGIN}"
   java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin ${PLUGIN}.hpi
done

echo "Copying over master global files"
cp ../../cfg/global/master/*.xml .
API_KEY=$(cat ../../cfg/global/master/apikey.txt)
sed -i "s/demotoken/${API_KEY}/" org.jenkinsci.plugins.ghprb.GhprbTrigger.xml


echo "Installing slave"
SLAVE_PATH=$(pwd | sed 's/master/slave/g' | sed 's/\/jenkins$//g' | sed 's/\//\\\//g')
cp ../../cfg/global/slave/node.xml node-template.xml
sed -i "s/slavepath/${SLAVE_PATH}/" node-template.xml
java -jar jenkins-cli.jar -s http://localhost:8080 create-node slave < node-template.xml

echo "Restarting Jenkins"
java -jar jenkins-cli.jar -s http://localhost:8080 restart

echo "Sleeping 30s"
sleep 30
popd
echo "Installing jobs"
pushd ../cfg/jobs
for JOB in $(ls *.xml)
do
   echo "Installing job ${JOB}"
   NAME=$(echo ${JOB} | awk -F'.xml' '{print $1}')
   java -jar ../../master/jenkins/jenkins-cli.jar -s http://localhost:8080 create-job ${NAME} < ${JOB}
done
popd
