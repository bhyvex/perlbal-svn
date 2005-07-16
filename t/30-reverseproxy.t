#!/usr/bin/perl

use strict;
use Perlbal::Test;
use Perlbal::Test::WebServer;
use Perlbal::Test::WebClient;
use Test::More 'no_plan';

# option setup
my $start_servers = 3; # web servers to start

# helper routines
sub status {
    my $port = shift;

}

# setup a few web servers that we can work with
my @web_ports = map { start_webserver() } 1..$start_servers;
@web_ports = grep { $_ > 0 } map { $_ += 0 } @web_ports;
ok(scalar(@web_ports) == $start_servers, 'web servers started');

# setup a simple perlbal that uses the above server
my $pb_port = new_port();
my $conf = qq{
CREATE POOL a

CREATE SERVICE test
SET test.role = reverse_proxy
SET test.listen = 127.0.0.1:$pb_port
SET test.persist_client = 1
SET test.persist_backend = 1
SET test.pool = a
ENABLE test

};

$conf .= "POOL a ADD 127.0.0.1:$_\n"
    foreach @web_ports;

my $msock = start_server($conf);
ok($msock, 'perlbal started');

#my $pid = status($web_port);

1;
