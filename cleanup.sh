#!/bin/bash

echo "Shutting down master jenkins"
cd master
./stop.sh
cd ..
echo "Shutting down demo server"
cd slave/workspace/demo.deploy/bin
./stop.sh
cd ../../../..
echo "Cleaning up master server"
rm -rf master/jenkins
rm -f master/*.log
rm -f *.hpi
rm -f *.war

echo "Cleaning up slave"
rm -rf slave/*
