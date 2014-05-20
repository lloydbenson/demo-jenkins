#!/bin/bash

ROOT_DIR=$(dirname $(readlink -f $0) | sed 's/\/bin$//')

## setup ssh keys
if [ ! -e ~/.ssh/id_rsa.pub ];
then
   ## generating a ssh key
   echo "Generating an rsa ssh key, please hit enter twice"
   ssh-keygen -t rsa
fi

PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
if [ $(grep -e "${PUB_KEY}" ~/.ssh/authorized_keys | wc -l) -eq 0 ];
then
   echo "Adding ssh key to your authorized_keys file for demo"
   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   echo yes | ssh localhost
   exit
fi

if [ ! -d "${ROOT_DIR}/master" ];
then
   echo "mkdir -p ${ROOT_DIR}/master"
   mkdir -p ${ROOT_DIR}/master
fi

if [ ! -e ${ROOT_DIR}/master/.bashrc ];
then
   cp ${ROOT_DIR}/cfg/.bashrc ${ROOT_DIR}/master
   ## when passing we have to fix it up so it handles the /
   MASTER_DIR=$(echo "${ROOT_DIR}/master" | sed 's/\//\\\//g')
   sed -i "s/jenkinsmasterpath/${MASTER_DIR}/" ${ROOT_DIR}/master/.bashrc
fi

pushd ${ROOT_DIR}/master

echo "Downloading latest jenkins"

JENKINS_SITE="http://mirrors.jenkins-ci.org"
## lts
JENKINS_PATH="/war-stable/latest/jenkins.war"
## if you like bleeding edge
#JENKINS_PATH="/war/latest/jenkins.war"

if [ ! -e jenkins.war ];
then
   curl -s -L -O ${JENKINS_SITE}/war-stable/latest/jenkins.war
   if [ $(file jenkins.war | grep -i html | wc -l) -gt 0 ];
   then
      echo "jenkins.war may not have been downloaded correctly.  try again."
      rm -f jenkins.war
      exit 2
   fi
fi

## grab plugins
PLUGINS="github-api github git-client scm-api git ghprb greenballs token-macro email-ext postbuildscript dashboard-view nodejs"

for PLUGIN in ${PLUGINS}
do
   echo "Downloading plugin ${PLUGIN}"
   if [ ! -e ${PLUGIN}.hpi ];
   then
      curl -s -L -O http://updates.jenkins-ci.org/latest/${PLUGIN}.hpi
      if [ $(file ${PLUGIN}.hpi | grep -i html | wc -l) -gt 0 ];
      then
         echo "${PLUGIN}.hpi may not have been downloaded correctly.  try again."
         rm -f ${PLUGIN}.hpi
         exit 2
      fi
   fi
done
