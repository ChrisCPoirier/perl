#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
require 'quicksort.pl';
use Test::More;




my @array = (1,2,3,4,5,6,7,8,9,10);
my @expected = @array;
my $p = @array;
quickSort(\@array,0,$p-1);

ok(@array eq @expected,"already sorted array");

@array = (10,9,8,7,6,5,4,3,2,1);
@expected = (1,2,3,4,5,6,7,8,9,10);
$p = @array;
quickSort(\@array,0,$p-1);

ok(@array eq @expected,"sort reversed array");


@array = (3,7,8,2,1,6,4,5,9,10);
@expected = (1,2,3,4,5,6,7,8,9,10);
$p = @array;
quickSort(\@array,0,$p-1);

ok(@array eq @expected,"sort mixed array");

@array = (7,2,-1,5,-3);
@expected = (-3,-1,2,5,7);
$p = @array;
quickSort(\@array,0,$p-1);

ok(@array eq @expected,"sort negatives");

@array = (2,5,2,5,2,5,2,5);
@expected = (2,2,2,2,5,5,5,5);
$p = @array;
quickSort(\@array,0,$p-1);

ok(@array eq @expected,"sort duplicates");

@array = (3,1.1,5,2.3,4);
@expected = (1.1,2.3,3,4,5);
$p = @array;
quickSort(\@array,0,$p-1);

ok(@array eq @expected,"sort floats");

@array = ('C','z','b','a');
@expected = ('a','b','C','z');
$p = @array;
quickSort(\@array,0,$p-1);

ok(@array eq @expected,"sort Strings");

foreach my $count (1..10) {
  @array = map { rand } ( 1..100 );
  @expected = sort {$a <=> $b}  @array;
  $p = @array;
  quickSort(\@array,0,$p-1);

  ok(@array eq @expected,"test random 100 records sort $count of 10");
}
done_testing();
