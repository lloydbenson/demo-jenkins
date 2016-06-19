This is a jenkins demo.  Here are the steps to set it up.

1.  Install ansible 2.x
2.  bin/reset.sh - this resets the environment
3.  bin/deploy.sh - this will setup up the jenkins server.  To access it go to http://localhost:8080

After configure you should see on http://localhost:8080
1.  within 1 min the demo.pr and demo.test jobs should start (if PR has been setup properly)
2.  demo.pr will eventually fail because the PR is purposefully broke (if PR has been setup properly)
3.  demo.test should produce a coverage report and tap results and pass successfully.
4.  demo.test success will trigger a demo.build
5.  demo.build will make an artifact with a unique identifier in the filename and be a .tar.gz file
6.  demo.build will be successful and cause demo.deploy to be triggered
7.  demo.deploy will deploy the last successful build artifact and startup a server http://localhost:8888/examples/hello

The PR portion of the demo will not work for you for obvious security reasons.  If you want to see it work, you can change the following:

1.  setup a user with pull/push privs for your own repo
2.  add ssh key from your machine where jenkins is running to the user
3.  to go the global configuration and put in your github.com api key for that user (you can generate one in that same location)
4.  change the lloyddemo user in the global configuration to your user
5.  change the lloyddemo user in the demo.pr job to your user
6.  change the git repo in the pr job to your own repo
7.  change the build block to do whatever logic you need for your testing

if you actually tried this out, let me know that it worked!
