![Hopper](http://cl.ly/2j2J1e2l15161h17352n/hopper.png)

## Hopper

Hopper is:

- Dennis Hopper.
- Grace Hopper - Pioneered [COBOL](http://en.wikipedia.org/wiki/COBOL) and high level progamming languages. Wrote the first compiler.
- A young, low-level drug dealer.
- A funnel-shaped chamber or bin in which loose material, as grain or coal, is
  stored temporarily.

This Hopper is more like the last one. Except with code.

## Code Analysis

Hopper is designed to collect, analyze, and report on code on a community level.
Here's an example workflow:

- Download a project
- Run that project through a battery of heuristics
- Record those results

Then we do this a few thousand times. This lets us analyze languages from a
community standpoint. How do we write our methods? What's the normal lifecycle
of a programming project? Has our style writing of code changed over time?

## Installation

First, install redis. This might be as easy for you as `brew install redis`.

Next, install Hopper:

    git clone https://github.com/holman/hopper.git
    script/server

You should be up and running on [http://localhost:9393](http://localhost:9393).
This loads up the development environment (with `shotgun`), so you'll need to
adjust the command to use Unicorn in production.

## The App

Hopper is a Redis-backed Sinatra app. Its purpose is to churn through a pile of
repository links, download them, and run a bunch of Probes on it.

A **Probe** is an analysis of a particular aspect of the project. Internally,
each specific probe inherits from the Probe class, which is a standard interface
that we can access to run all of these probes. An example might be an LOC Probe,
which counts the lines of code in a project.

Reporting is all done via the web app. This is where all of the adorable graphs
and pretty statistics get gathered.

## Indexing

Indexing is a little more complex. First, if you just want some data to play
around with, run:

    rake setup

This will clone down six repos locally for you to play with. You'll then want to
start up the Resque job server:

    foreman start jobs

If you want to index other projects, run:

    rake console
    Hopper::Github.indexing(true)
    Hopper::Github.async_index

This will kick of jobs to index projects from GitHub. To actually start the
jobs, run:

    foreman start jobs

This will run one worker on all queues. Since the indexing job will go forever,
you'll want to [monitor Resque](http://localhost:9393/resque) and see until a
reasonable about of `Index` and `Probe` jobs are queued up. When you've reached
a reasonable level:

    rake console
    Hopper::Github.indexing(false)

That will end the download job, so your one worker will then go on to process
your new `Index` and `Probe` jobs.

## Hopper

Hopper is a [@holman](https://twitter.com/holman) joint.