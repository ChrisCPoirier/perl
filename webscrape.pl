### create a routine to scrape a webpage
### and find all urls on that page and
### scrape all subpages for their urls
### up to x levels deep.
### also scrape specific key words
use strict;
use warnings;
use LWP::Simple;


sub getWebContent {
    my ($url) = @_;
    my $content = get $url;
    return $content;
}


sub getUrls {
  my ($content) = @_;

  my @urls = $content =~ /href="([\S]+)"/g;
  return @urls;
}


my $content = getWebContent("http://www.cnn.com/tech");

my @urls = getUrls($content);

print join("\n",@urls) ."\n";




#1 at end of file so inluce returns true;
1;
