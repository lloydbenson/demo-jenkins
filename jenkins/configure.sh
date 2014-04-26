#!/bin/bash
## download the cli
pushd jenkins
curl -s -L -O http://localhost:8080/jnlpJars/jenkins-cli.jar
## install plugins
PLUGINS="github-api git-client scm-api git ghprb email-ext greenballs token-macro email-ext postbuildscript"

for PLUGIN in ${PLUGINS}
do
   echo "Installing plugin ${PLUGIN}"
   java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin ${PLUGIN}.hpi
done

echo "Restarting Jenkins"
java -jar jenkins-cli.jar -s http://localhost:8080 restart

sleep 15

echo "Installing jobs"
