#!/bin/bash

echo "Shutting down master jenkins"
master/stop.sh
echo "Shutting down demo server"
if [ -e "slave/workspace/demo.deploy/bin/stop.sh" ];
then
   slave/workspace/demo.deploy/bin/stop.sh
fi
echo "Cleaning up master server"
rm -rf master/jenkins
rm -f master/*.log
rm -f *.hpi
rm -f *.war

echo "Cleaning up slave"
rm -rf slave/*
