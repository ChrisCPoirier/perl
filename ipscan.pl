#!/usr/bin/perl

use strict;
use warnings;
use Net::Ping;
use POSIX qw(strftime);
#TODO: Bring back to auto determine number of threads
#use Sys::Info;
#use Sys::Info::Constants qw( :device_cpu );

sub scan {
  #TODO: make this a prompt for user input if not suplied
  my ($ip_and_mask, $cores) = @_;
  my @ipaddresses = generate_ips($ip_and_mask);


  #TODO: Bring back to auto detect threads
  #my $cores = get_cpu_cores();
  my $span = @ipaddresses / $cores;
  foreach my $counter (0..$cores-1) {
    my $pid = fork();
    #could not create child
    die if not defined $pid;
    #if not $pid then we know we are not in child
    if (not $pid) {
       #inside child
       my $begin = ($span*$counter);
       my $end = $begin + $span;
       for my $ipaddress (@ipaddresses[$begin..$end]) {
           pingip($ipaddress);
       }
       exit;
    }
  }
  #wait for threads to finish, need amount of waits equal to amount of active
  #cores
  for (1 .. $cores) {
   my $finished = wait();
}
  print "all finished!!!";
}

sub pingip {
  my ($host) = @_;
  my $p = Net::Ping->new("tcp",.10);
  if ($p->ping($host)) {
    print "$host is alive.\n"
  } else {
    print "$host cannot be reached.\n"
  }

  $p->close();
}

sub generate_ips {
  my ($subnet_mask) = @_;
  my @result = ();
  my $subnets = "";
  my $ipmask = "";

  #TODO: Add regular expression to find and warn on badly formatted ip/mask strings
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
scan("192.168.0.0/16",8);

my $End = time();
my $Diff = $End - $Start;
$Start = strftime "%H:%M:%S", localtime($Start);
$End = strftime "%H:%M:%S", localtime($End);
print "Start ".$Start."\n";
print "End ".$End."\n";
print "Diff ".$Diff."\n";

#TODO: Bring back to auto determine number of threads
#sub get_cpu_cores {
#  my $info = Sys::Info->new;
#  my $cpu  = $info->device( CPU => %options );
#
#  return $cpu->count || 1;
#}
