#!/bin/bash

## stop
java -jar jenkins/jenkins-cli.jar -s http://localhost:8080 shutdown >/dev/null 2>&1
