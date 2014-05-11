jenkins demo

This is a jenkins demo.  Here are the steps to set it up.

1.  ./prepare.sh - this downloads the software, plugins, and sets up some initial stuff before we start up the master jenkins server.
2.  cd master; ./start.sh - this will start up the jenkins server.  To access it go to http://localhost:8080
3.  cd master; ./configure.sh - this will install the main config, ssh slave, plugins, and setup some example jobs.
4.  cd master; ./stop.sh - this will stop jenkins
5.  ./cleanup.sh - this will stop and then cleanup all the files that got generated for nice cleanup
