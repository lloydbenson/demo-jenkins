#!/bin/bash

ROOT_DIR=$(dirname $(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)  | sed 's/\/bin$//')

echo "Shutting down master jenkins"
${ROOT_DIR}/bin/stop.sh
echo "Shutting down demo server"
if [ -e ${ROOT_DIR}/slave/workspace/demo.deploy/app/demo-hapi/bin/stop.sh ];
then
   ${ROOT_DIR}/slave/workspace/demo.deploy/app/demo-hapi/bin/stop.sh
fi
echo "Cleaning up master server"
rm -rf ${ROOT_DIR}/master
rm -f ${ROOT_DIR}/*.hpi
rm -f ${ROOT_DIR}/*.war

echo "Cleaning up slave"
rm -rf ${ROOT_DIR}/slave
