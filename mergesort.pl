#!/usr/bin/perl
#use strict;
#use warnings;
use v5.10;

sub mergesort {
  my (@arr) = @_;
  #print "array count is: @arr\n";
  return @arr if @arr == 1;
  my $span = @arr/2;
  my @arr1 = @arr[0..$span-1];
  my @arr2 = splice @arr, $span;

  @arr1 = mergesort(@arr1);
  @arr2 = mergesort(@arr2);
  return merge(\@arr1, \@arr2);
}

sub merge {
  my ($arr1, $arr2) = @_;
  my @result = ();
  while(@$arr1 or @$arr2) {
    #print "@$arr1\n";
    #print "@$arr2\n";
    if (@$arr1 == 0) {
      push @result, @$arr2;
      return @result;
    } elsif (@$arr2 == 0) {
      push @result, @$arr1;
      return @result;
    } else {
      if ($$arr1[0] > $$arr2[0]) {
        my $temp = shift $arr2;
        push @result, $temp;
      } else {
        my $temp = shift $arr1;
        push @result, $temp;
      }
    }
  }

}

#@test1 = (3,4,5,6);
#@test2 = (2);

#@test = merge(\@test1,\@test2);
#print (@test);
#print "\n";
#print "my result is: "+ @result +"\n";
my @test = (3,4,1,5,6);
print mergesort(@test);
