#use strict;
#use warnings;
use v5.10;

sub quickSort {
  my ($arr, $wall, $pivot) = @_;
  my $origin = 0;
  my $temp = 0.0;
  if ( $pivot - $wall > 0 ) {
    $origin = $wall;
    foreach my $cur ($origin..$pivot) {
      #if(ord($$arr[$cur]) < ord($$arr[$pivot]) || $cur == $pivot) {
      if($$arr[$cur] < $$arr[$pivot] || $cur == $pivot) {
        $temp = $$arr[$cur];
        ${$arr}[$cur] = $$arr[$wall];
        ${$arr}[$wall] = $temp;
        unless ($cur == $pivot) {
          $wall += 1;
        }
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
#require requires the file to return true. Using 1 as a representation of true.
1;
