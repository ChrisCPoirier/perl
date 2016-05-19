#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
require 'ipscan.pl';
use Test::More;

#Example
#my @array = (1,2,3,4,5,6,7,8,9,10);
#my @expected = @array;
#my $p = @array;
#quickSort(\@array,0,$p-1);

#ok(@array eq @expected,"already sorted array");

#TODO: Create Tests for sub->scan
#TODO: create tests for pingip
#TODO: Create test for generate_ips
#TODO: Create test for generate_parts

my $Start = time();
my ($good, $bad) = scan("192.168.0.0/24",10);

print "********GOOD*********\n";
print join("\n",@$good) . "\n";
print "********BAD**********\n";
print join("\n",@$bad) . "\n";
print "********STATS********\n";
my $End = time();
my $Diff = $End - $Start;
$Start = strftime "%H:%M:%S", localtime($Start);
$End = strftime "%H:%M:%S", localtime($End);
print "Start ".$Start."\n";
print "End ".$End."\n";
print "Diff ".$Diff."\n";



done_testing();
