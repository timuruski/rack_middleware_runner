RACK MIDDLEWARE RUNNER
======================

This is the project runner for the Rack middleware exercise. It runs a set of
processes to provide an interactive experience for the participants. It works by
running the following:

 * Monitor - This hosts the single-page JS app that sends sample requests to
   the middleware stack, it also acts as a webhooks handler for GitHub.
 * Runner - This runs a set of dynamically loaded middleware stacks, namespaced
   to the pull requests in the vendor directory.
 * Worker - This fetches new commits from GitHub and triggers rolling-restarts
   of the runner.

Use foreman to start the process:

    foreman start


Requirements:
-------------

 * Ruby and foreman (of course)
 * Postgresql or Redis (something with pub/sub)
