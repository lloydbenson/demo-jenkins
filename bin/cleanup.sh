#!/bin/bash

echo "Shutting down master jenkins"
bin/stop.sh
echo "Shutting down demo server"
if [ -e "slave/workspace/demo.deploy/bin/stop.sh" ];
then
   slave/workspace/demo.deploy/bin/stop.sh
fi
echo "Cleaning up master server"
rm -rf master
rm -f *.hpi
rm -f *.war

echo "Cleaning up slave"
rm -rf slave
