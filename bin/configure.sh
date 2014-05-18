#!/bin/bash

PORT=8081
pushd master
## download the cli
echo "Downloading the CLI from localhost"
curl -s -L -O http://localhost:${PORT}/jnlpJars/jenkins-cli.jar
## install plugins
## order matters with installation due to dependencies
PLUGINS="github-api github git-client scm-api git ghprb greenballs token-macro email-ext postbuildscript dashboard-view nodejs"

for PLUGIN in ${PLUGINS}
do
   echo "Installing plugin ${PLUGIN}"
   java -jar jenkins-cli.jar -s http://localhost:${PORT} install-plugin ${PLUGIN}.hpi
   echo "Cleanup plugins"
   rm -f ${PLUGIN}.hpi
done

echo "Copying over master global files"
cp ../cfg/global/master/*.xml .
API_KEY=$(cat ../cfg/global/master/apikey.txt)
sed -i "s/demotoken/${API_KEY}/" org.jenkinsci.plugins.ghprb.GhprbTrigger.xml


echo "Installing slave"
SLAVE_PATH=$(pwd | sed 's/master/slave/g' | sed 's/\/jenkins$//g' | sed 's/\//\\\//g')
cp ../cfg/global/slave/node.xml node-template.xml
sed -i "s/slavepath/${SLAVE_PATH}/" node-template.xml
java -jar jenkins-cli.jar -s http://localhost:${PORT} create-node slave < node-template.xml

echo "Restarting Jenkins"
java -jar jenkins-cli.jar -s http://localhost:${PORT} restart

echo "Sleeping 30s"
sleep 30
popd
echo "Installing jobs"
pushd cfg/jobs
for JOB in $(ls *.xml)
do
   NAME=$(echo ${JOB} | awk -F'.xml' '{print $1}')
   echo "Installing job ${NAME}"
   java -jar ../../master/jenkins-cli.jar -s http://localhost:${PORT} create-job ${NAME} < ${JOB}
done
popd
