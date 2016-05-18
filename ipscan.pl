#!/usr/bin/perl

use strict;
use warnings;
use Net::Ping;
use POSIX qw(strftime);

sub scan {
  #TODO: make this a prompt for user input if not suplied
  my ($ip_and_mask, $threads) = @_;
  #TODO: Add regular expression to find and warn on badly formatted ip/mask strings
  die "badly formatted ip/subnet. must be in x.x.x.x/x form " unless $ip_and_mask =~ /(\d{1,3}\.){3}\d{1,3}\/(8|16|24|32)/;

  my @ipaddresses = generate_ips($ip_and_mask);

  my $span = @ipaddresses / $threads;
  foreach my $counter (0..$threads-1) {
    my $pid = fork();
    #could not create child
    die if not defined $pid;
    #if not $pid then we know we are not in child
    if (not $pid) {
       #inside child
       my $begin = ($span*$counter);
       my $end = $begin + $span;
       my $result;
       for my $ipaddress (@ipaddresses[$begin..$end]) {
           $result = pingip($ipaddress);
           print $result;
       }
       exit;
    }
  }

  #wait for threads to finish, need amount of waits equal to amount of active
  for (1 .. $threads) {
    my $finished = wait();
  }
  #TODO: change result to multi part array.
  #       success and non-success arrays.
  #       Somehow receive return data from forks
  print "all finished!!!";
}

sub pingip {
  my ($host) = @_;
  $host //= "";
  my $p = Net::Ping->new("tcp",.10);
  if ($p->ping($host)) {
    return "$host is alive.\n"
  } else {
    return "$host cannot be reached.\n"
  }

  $p->close();
}

sub generate_ips {
  my ($subnet_mask) = @_;
  my @result = ();
  my $subnets = "";
  my $ipmask = "";

  if(index($subnet_mask,"/")) {
    $subnets = substr $subnet_mask,index($subnet_mask,"/")+1;
    $ipmask =  substr $subnet_mask,0,index($subnet_mask,"/");
  } else {
    $subnets = 0;
    $ipmask =  $subnet_mask;
  }

  my @ipparts = split(/[.\n]/,$ipmask);
  push @result, generate_parts(\@ipparts,1,$subnets,'');

  return @result;
}

sub generate_parts {
  my ($ip,$index,$subnet,$part) = @_;
  if($index > 4) {
    return $part;
  }
  unless($part eq "") {
    $part .= ".";
  }
  my @lresult = ();
  if(8*$index <= $subnet ) {
    push @lresult, generate_parts($ip,$index+1,$subnet,$part.$$ip[$index-1]);
  } else {
    foreach my $cur (0..255) {
      push @lresult, generate_parts($ip,$index+1,$subnet,$part.$cur);
    }
  }
  return @lresult;
}

my $Start = time();
scan("192.168.0.0/24",10);

my $End = time();
my $Diff = $End - $Start;
$Start = strftime "%H:%M:%S", localtime($Start);
$End = strftime "%H:%M:%S", localtime($End);
print "Start ".$Start."\n";
print "End ".$End."\n";
print "Diff ".$Diff."\n";
