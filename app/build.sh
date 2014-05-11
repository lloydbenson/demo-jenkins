#!/bin/bash

echo "Building hapi demo"
rm -f hapidemo.tar.gz
rm -rf hapi/node_modules
cd hapi
npm install
npm test
rm -rf node_modules
npm install --production
cd ..
tar cvfz hapidemo.tar.gz hapi
