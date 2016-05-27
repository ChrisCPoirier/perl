#!/usr/bin/perl
=head1 NAME
ipscan
=head1 SYNOPSIS
    call ipscan :: scan(xx.xx.xx.xx/xx,[z])
    to scan a all ips on a particular ip/subnet(x) using amount of threads(z)
=cut
use strict;
use warnings;
use Net::Ping;
use forks;
use forks::shared;

=item scan()

This is function receives an ipaddress/mask with an optional thread count.
It then creates a list of every IP address on that subnet
and returns a list of Good Pings and Bad Pings.

Input:  [$ip_and_mask], [$threds]

Output: { @good, @bad }

Input:
        $ip_and_mask - ip and mask formated as 192.168.0.10/24
        $threads - optional paramter to specifiy number of threads to use

Output:
        Reference to two arrays
            @good - list of successfull pings
            @bad - list of unsuccessful pings

=cut

sub scan {
  my ($ip_and_mask, $threadCount) = @_;
  $threadCount //= 1;

  #if no IP specified, the process will prompt
  if (not defined($ip_and_mask)) {
    print "Enter an ip address/mask formated as xx.xx.xx.xx/xx input:\n";
    $ip_and_mask = <STDIN>;
    chomp $ip_and_mask;
  }

  if($ip_and_mask =~ /(^\/)/) {
    $ip_and_mask .= "/0";
  }

  #if IP/mask is not formated properly warn user and die
  die "badly formatted ip/subnet. must be in x.x.x.x/x form "
    unless $ip_and_mask =~ /(\d{1,3}\.){3}\d{1,3}\/(8|16|24|32)/;

  #generate list of ip addresses
  my @ipaddresses = generate_ips($ip_and_mask);

  my $span = @ipaddresses / $threadCount;
  my @threadList;

  foreach my $counter (0..$threadCount-1) {
    #generate thread and push refrence on stack
    push @threadList, threads->create( sub {
       my $begin = ($span*$counter);
       my $end = $begin + $span;
       my (@good,@bad);
       for my $ipaddress (@ipaddresses[$begin..$end]) {
         pingip($ipaddress) ? push @good, $ipaddress : push @bad, $ipaddress;
       }
      return (\@good, \@bad);
    });
  }

  #wait for threads to finish, need amount of waits equal to amount of active
  my @finalgood;
  my @finalbad;
  for my $thread (@threadList) {
      my ($good, $bad) = $thread->join();
      push @finalgood, @$good;
      push @finalbad, @$bad;
  }
  return (\@finalgood, \@finalbad);
}

=item pingip()

This is function pings a provided ip address with a 10th of a second wait.

Input:  $host

Output: { $host, $message }

Input:
        $host - ip address to ping

Output:
        Reference to two arrays
            $host - the ip address that was pinged
            $message - the message from that ping request

=cut

sub pingip {
  my ($host) = @_;
  $host //= "";
  my $p = Net::Ping->new("tcp",.20);
  return ($p->ping($host)) ? 1: 0;
}

=item generate_ips()

This funcion generates a list of ipaddresses from ip/subnet

Input:  $ipAndSubnet

Output: { @ipaddresses }

Input:
        $ipAndSubnet - ip address and subnet mask

Output:
        Returns list of ips as array
            @ipaddresses - the ip address that were generated

=cut

sub generate_ips {
  my ($ipAndSubnet) = @_;
  $ipAndSubnet =~ /([\d\.]+(?=\/?))(?:\/(\d\d))?/;
  my @ipparts = split(/[.]/,$1);
  return generate_parts(\@ipparts,1,$2,'');
}


=item generate_parts()

This functions generates the parts to the ipaddresses recursively.

Input:  $ip,$index,$subnet,$part

Output: { @lresult }

Input:
        $ip - the list of ip parts from the original passed in ip
        $index - what level deep are we
        $subnet - the subnet mask rule to adhere to
        $part - the piece of ip to tack onto

Output:
        Returns all ip addresses recursively
            @lresult - the ip address that were generated

=cut

sub generate_parts {
  my ($ip,$index,$subnet,$part) = @_;
  my @lresult;
  if($index > 4) {
    return $part;
  }

  $part .= "." unless($part eq "");

  if(8*$index <= $subnet ) {
    push @lresult, generate_parts($ip,$index+1,$subnet,$part.$$ip[$index-1]);
  } else {
    foreach my $cur (0..255) {
      push @lresult, generate_parts($ip,$index+1,$subnet,$part.$cur);
    }
  }
  return @lresult;
}
1;
