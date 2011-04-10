Ruby Revisor Client Library
===================

This library provides object-oriented interface for executing commands
on [Revisor](http://github.com/sotakone/revisor) server. Althrough you
can send commands with any HTTP client, this library might save you
some time collecting command arguments and handling server responses
for you. It also includes some examples and test suite.

Installation
----------

Revisor Client Library is available via RubyGems:

    $ gem install revisor_client

Usage
----------

Location of Revisor executable
----------

Client library expects your Revisor executable will be in PATH, or
it's location is set in REVISOR_PATH environment variable.

Running tests
----------

Execute following command inside cloned Git repository or installed
gem folder:

    $ rake test REVISOR_PATH=/path/to/your/revisor/executable

Copyrights
----------

Copyright (c) 2009 Mikhail Lapshin (sotakone at sotakone dot com),
released under the MIT license.
