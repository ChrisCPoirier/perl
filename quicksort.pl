#!/usr/bin/perl
#use strict;
#use warnings;
use v5.10;

sub quickSort {
  my ($arr, $wall, $pivot) = @_;
  my ($origin,$temp);
  if ( $pivot - $wall > 0 ) {
    $origin = $wall;
    foreach my $cur ($origin..$pivot) {
      if($$arr[$cur] < $$arr[$pivot] || $cur == $pivot) {
        @$arr[$cur,$wall] = @$arr[$wall,$cur];
        unless ($cur == $pivot) {
          $wall += 1;
        }


        adaasc
      }
    }
    if ($wall - 1 - $origin >0) {
      quickSort($arr, $origin, $wall-1 );
    }
    if ($pivot - $wall+1 > 0) {
      quickSort($arr, $wall+1, $pivot );
    }
  }
}
#require from another file requires the file to return true.
#Using 1 as a representation of true.
1;
