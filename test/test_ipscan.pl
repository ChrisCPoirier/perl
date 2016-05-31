#!/usr/bin/perl
#use strict;
#use warnings;
use v5.10;
require 'ipscan.pl';
use Test::More;
use POSIX qw(strftime);

#Tests for sub->scan
my ($good, $bad) = scan("192.168.0.0/24",10);
ok( "192.168.0.1" ~~ @$good && "192.168.0.255" ~~ @$bad,
  "test scan: may fail if ip/subnets are different");

#tests for pingip
ok(pingip("localhost") eq 1,"ping local host");

#tests for generate_ips, proves generate parts in the context we need.
my @testarray = ("192.168.0.1");
ok(generate_ips("192.168.0.1/32") eq @testarray,"generate ips:simple");

@testarray = ("192.168.0.0","192.168.0.1",
  "192.168.0.2","192.168.0.3","192.168.0.4","192.168.0.5");
my @resultarray = generate_ips("192.168.0.1/24");
ok(@resultarray[0..5] ~~ @testarray &&
  @resultarray == 256,"generate ips:complex");


done_testing();
