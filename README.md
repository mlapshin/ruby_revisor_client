Ruby Revisor Client Library
===================

This library provides object-oriented interface for executing commands
on [Revisor](http://github.com/sotakone/revisor) server. Althrough you
can send commands with any HTTP client, this library might save you
some time collecting command arguments and handling server responses
for you. It also includes some examples and test suite.

Location of Revisor executable
----------

Client library expects your Revisor executable will be in PATH, or
it's location is set in REVISOR_PATH environment variable.

Running examples (GMail test)
----------

    $ rake examples REVISOR_PATH=/path/to/your/revisor/executable
    
Running tests
----------

    $ rake test REVISOR_PATH=/path/to/your/revisor/executable
