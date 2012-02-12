![Hopper](http://cl.ly/2j2J1e2l15161h17352n/hopper.png)

## Hopper

Hopper is:

- Dennis Hopper.
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

    git clone https://github.com/holman/hopper.git
    script/server

You should be up and running on [http://localhost:3000](http://localhost:3000).

## The App

Hopper is a Redis-backed Sinatra app. Its purpose is to churn through a pile of
repository links, download them, and run a bunch of Probes on it.

A **Probe** is an analysis of a particular aspect of the project. Internally,
each specific probe inherits from the Probe class, which is a standard interface
that we can access to run all of these probes. An example might be an LOC Probe,
which counts the lines of code in a project.

Probes are kicked off... somehow.

Reporting is all done via the web app. This is where all of the adorable graphs
and pretty statistics get gathered.

## Hopper

Hopper is a [@holman](https://twitter.com/holman) joint.