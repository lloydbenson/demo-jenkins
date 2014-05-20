#!/bin/bash

ROOT_DIR=$(dirname $(readlink -f $0) | sed 's/\/bin$//')
echo "Shutting down master jenkins"
${ROOT_DIR}/bin/stop.sh
echo "Shutting down demo server"
if [ -e "${ROOT_DIR}/slave/workspace/demo.deploy/bin/stop.sh" ];
then
   ${ROOT_DIR}/slave/workspace/demo.deploy/bin/stop.sh
fi
echo "Cleaning up master server"
rm -rf ${ROOT_DIR}/master
rm -f ${ROOT_DIR}/*.hpi
rm -f ${ROOT_DIR}/*.war

echo "Cleaning up slave"
rm -rf ${ROOT_DIR}/slave
