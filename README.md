These are some scripts I created on my Journey to learn Perl.
hello.pl:
Initial test script to get the syntax of perl locked down.

ipscan.pl:
A Multi threaded ip ping utility. Essentiall feed it a ip/subnet(192.168.0.0/24)
  and the process will generate all ip addresses based on the value of the subnet
  combined with the base ip. This example would create a list of ip addresses
  containing (192.168.0.0,192.168.0.1,192.168.0.2....192.168.0.255)

  quicksort.pl:
  My implementation of quicksort in perl. Created Just for testing.

  webscrape.pl:
  The intent is to create a multi threaded process to scrape a webpage for all
    URI's and then subsequently scrape those pages up to n levels deep.
