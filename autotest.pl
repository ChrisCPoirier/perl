use strict;
use warnings;
use File::Monitor;
=head1 NAME
autotest
=head1 SYNOPSIS
    function to monitor changes to files in a directory and Run
    the test assocaited to that file. This is essentially a poor mans
    CIT(Continual Integeration Testing)
=cut

my $codedir ='/home/chris/git-repos/perl';

my $monitor = File::Monitor->new();
my @files = listFiles($codedir);

for my $file (@files) {
  $monitor->watch({
    name => $file,
    #files => 1,
    callback => sub {
        my ($name, $event, $change) = @_;
        $name =~ /(\w+)\.pl$/
        and print "Running test for: $1\n" and
        do {eval{ `perl /home/chris/git-repos/perl/test/test_$1.pl`}};
        print "test complete.\n";
      }
  });
}

$monitor->scan;

while (1) {
  sleep(5.10);
  $monitor->scan;
}


sub listFiles {
  my($dir)  = @_;
  my @result;
  opendir(DIR, $dir) or die $!;
  while (my $file = readdir(DIR)) {
    next if (-d "$dir/$file");
    push @result, "$dir/$file";
  }
  return @result;
}
