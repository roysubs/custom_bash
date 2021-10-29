#!/usr/bin/perl

use strict;

my $header = 1 if $#ARGV > 0;

while(<>) {
  if (($. == 1) && $header) {
    print "\n" if $header++ > 1;
    print "==> $ARGV <==\n"
  };

  if (/^\s*(?:function\s+)?([-\w]+)\s*\(\)/ ||
      /^\s*function\s+([-\w]+).*\{/) {
    printf "%5i\tfunction %s\n", $.,$1
  } elsif (/^\s*alias\s+([-\w]+)=/) {
    printf "%5i\talias %s\n", $.,$1
  };

  close(ARGV) if eof
}
