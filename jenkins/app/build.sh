#!/bin/bash

echo "Building App for 30s"
cd hapi
npm install
npm test
rm -rf node_modules
npm install --production
cd ..
tar cvfz hapidemo.tar.gz hapi
