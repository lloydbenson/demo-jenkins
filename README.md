jenkins demo

This is a jenkins demo.  Here are the steps to set it up.

1.  bin/prepare.sh - this downloads the software, plugins, and sets up some initial stuff before we start up the master jenkins server.
2.  bin/start.sh - this will start up the jenkins server.  To access it go to http://localhost:8081
3.  bin/configure.sh - this will install the main config, ssh slave, plugins, and setup some example jobs.
4.  bin/stop.sh - this will stop jenkins
5.  bin/cleanup.sh - this will stop and then cleanup all the files that got generated for nice cleanup
