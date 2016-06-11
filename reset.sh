#!/bin/bash

ansible-playbook -v hosts.yml -i hosts --tags reset
