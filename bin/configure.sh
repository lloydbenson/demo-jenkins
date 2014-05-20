#!/bin/bash

ROOT_DIR=$(dirname $(readlink -f $0) | sed 's/\/bin$//')
source ${ROOT_DIR}/master/.bashrc
pushd ${ROOT_DIR}/master
## download the cli
echo "Downloading the CLI from localhost"
curl -s -L -O http://localhost:${JENKINS_PORT}/jnlpJars/jenkins-cli.jar
## install plugins
## order matters with installation due to dependencies
PLUGINS="github-api github git-client scm-api git ghprb greenballs token-macro email-ext postbuildscript dashboard-view nodejs tap chucknorris htmlpublisher"

for PLUGIN in ${PLUGINS}
do
   echo "Installing plugin ${PLUGIN}"
   java -jar jenkins-cli.jar -s http://localhost:${JENKINS_PORT} install-plugin ${PLUGIN}.hpi
   echo "Cleanup plugins"
   rm -f ${PLUGIN}.hpi
done

echo "Copying over master global files"
cp ${ROOT_DIR}/cfg/global/master/*.xml .
API_KEY=$(cat ${ROOT_DIR}/cfg/global/master/apikey.txt)
sed -i "s/demotoken/${API_KEY}/" org.jenkinsci.plugins.ghprb.GhprbTrigger.xml

echo "Restarting Jenkins"
java -jar jenkins-cli.jar -s http://localhost:${JENKINS_PORT} restart
echo "Sleeping 30s"
sleep 30

echo "Installing slave"
SLAVE_PATH=$(pwd | sed 's/master/slave/g' | sed 's/\/jenkins$//g' | sed 's/\//\\\//g')
cp ${ROOT_DIR}/cfg/global/slave/node.xml node-template.xml
sed -i "s/slavepath/${SLAVE_PATH}/" node-template.xml
java -jar jenkins-cli.jar -s http://localhost:${JENKINS_PORT} create-node slave < node-template.xml
rm -f node-template.xml

popd
echo "Installing jobs"
pushd ${ROOT_DIR}/cfg/jobs
for JOB in $(ls *.xml)
do
   NAME=$(echo ${JOB} | awk -F'.xml' '{print $1}')
   echo "Installing job ${NAME}"
   java -jar ${ROOT_DIR}/master/jenkins-cli.jar -s http://localhost:${JENKINS_PORT} create-job ${NAME} < ${JOB}
done
popd
