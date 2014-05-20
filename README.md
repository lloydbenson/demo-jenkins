jenkins demo

This is a jenkins demo.  Here are the steps to set it up.

1.  bin/prepare.sh - this downloads the software, plugins, and sets up some initial stuff before we start up the master jenkins server.
2.  bin/start.sh - this will start up the jenkins server.  To access it go to http://localhost:8081
3.  bin/configure.sh - this will install the main config, ssh slave, plugins, and setup some example jobs.
4.  bin/stop.sh - this will stop jenkins
5.  bin/cleanup.sh - this will stop and then cleanup all the files that got generated for nice cleanup

The PR portion of the demo will not work for you due to obvious security reasons.  If you want to see it work, you can change the following:

1.  setup a user with pull/push privs for that repo
2.  add ssh key from your machine where jenkins is running to the user
3.  to go the global configuration and put in your github.com api key for that user (you can generate one in that same location)
4.  change the lloyddemo user in the global configuration to your user
5.  change the lloyddemo user in the demo.pr job to your user
6.  change the git repo in the pr job to your own repo

if you actually tried this out, let me know that it worked!
