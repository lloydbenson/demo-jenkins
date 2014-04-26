#!/bin/bash

## note not alot of error checking on valid downloads etc.  Use at your own risk!!
if [ ! -d "jenkins" ];
then
   echo "mkdir jenkins"
   mkdir jenkins
fi

pushd jenkins
echo "Downloading jenkins"
curl -s -L -O http://mirrors.jenkins-ci.org/war/latest/jenkins.war

## grab plugins
PLUGINS="github-api git-client scm-api git ghprb greenballs token-macro email-ext postbuildscript"

for PLUGIN in ${PLUGINS}
do
   echo "Downloading plugin ${PLUGIN}"
   curl -s -L -O http://updates.jenkins-ci.org/latest/${PLUGIN}.hpi
done
popd
