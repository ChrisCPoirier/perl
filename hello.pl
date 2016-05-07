#!/usr/bin/perl

#This will print "Hello, World"
print ("Hello, World\n");
print "Hello, World\n";

#this is a comment in perl denoted by the symbol(#)

=begin comment
This is all part of multiline comment
denoted by the symbol(=) all the way until an
equal sign followed by the word cut
=cut


#demonstarting how white space behaves in perl not in quotes
print           "Hello, world\n";

#in quotes

print "Hello
        World\n";


#single qoutes do not interpolate variables
print 'Hello, World\n';

print "\n";

#this allows large blocks of text and values to be replaced
#The text imediatley after the <<EOF will be assigned to the $var variable
#until EOF is found using double qoutes will ensure variables are replaced
#single qoutes will dicate that it will not be interpolate.

$a = 10;
$var = <<"EOF";
This is some text that will be assigned to var.
we can do multi line
to make variable assignments easy.
variables defined with dollar sign will be replaced.
Example \$a will become $a
EOF

print "$var\n";


#escaping characters uses \ key.
$result = "This is \"number\"";
print "$result\n";
print "\$result\n";
