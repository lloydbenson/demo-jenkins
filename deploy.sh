#!/bin/bash

#ansible-playbook -v hosts.yml -i hosts --tags what
ansible-playbook -v hosts.yml -i hosts --tags untagged
