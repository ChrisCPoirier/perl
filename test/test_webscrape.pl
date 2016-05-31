#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
require 'webscrape.pl';
use Test::More;



my $content = getWebContent("http://www.google.com");
ok($content =~ m/Google Search/i,"simple get web content");

done_testing();
