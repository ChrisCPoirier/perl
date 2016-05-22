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
    my $content = get($url);
}
