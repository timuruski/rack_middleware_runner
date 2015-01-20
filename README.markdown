RACK MIDDLEWARE RUNNER
======================

This is the project runner for the [Rack middleware exercise][rme]. It runs a
set of processes to provide an interactive experience for the participants. It
works by running the following:

 * Monitor - Hosts a single-page JS app that sends sample requests to
   the middleware stack, it also acts as a webhooks handler for GitHub.
 * Runner - Runs a set of dynamically loaded middleware stacks, namespaced
   to the pull requests in the `vendor` directory.
 * Worker - This fetches new commits from GitHub and triggers rolling-restarts
   of the runner.

[rme]:https://github.com/timuruski/rack_middleware_exercise

Use foreman to start the process:

    foreman start


Requirements:
-------------

 * Ruby and foreman (of course)
 * Postgresql or Redis (something with pub/sub)
