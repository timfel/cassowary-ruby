## Cassowary
[![Build Status](https://secure.travis-ci.org/timfel/cassowary.png?branch=master)](https://travis-ci.org/timfel/cassowary)

Cassowary is an incremental constraint solving toolkit that
efficiently solves systems of linear equalities and
inequalities. Constraints may be either requirements or
preferences. Client code specifies the constraints to be maintained,
and the solver updates the constrained variables to have values that
satisfy the constraints.

This is a Ruby port of the Smalltalk version of Cassowary. The
original distribution can be found
[here](http://www.cs.washington.edu/research/constraints/cassowary/).

A technical report is included in the original distribution that
describes the algorithm, interface, and implementation of the
Cassowary solver. Additionally, the distribution contains toy sample
applications written in Smalltalk, C++, Java, and Python, and a more
complex example Java applet, the "Constraint Drawing Application".
