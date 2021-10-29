#!/usr/bin/perl

use strict;
#use Data::Dump qw(dd);

my $f_re = qr/(?:^|&&|\|\||;|&)\s*(?:(?:function\s+)?([-\w.]+)\s*\(\)|function\s+([-\w.]+)\s+(?:\(\))?\s*\{)/;

my $a_re = qr/(?:^|&&|\|\||;|&)(?:\s*alias\s*)([-\w.]+)=/;

# Hash-of-Hashes (HoH) to hold function/alias names and the files/lines they
# were found on.  i.e an associative array where each element is another
# associative array.  Search for HoH in the perldsc man page.
my %fa;

while(<>) {
  while(/$f_re/g) {
      my $match = $1 // $2;
      #print "found: '$match':'$&':$ARGV:$.\n";
      $fa{$match}{"function $ARGV:$."}++;
  };
  while(/$a_re/g) {
      #print "found: '$1':'$&':$ARGV:$.\n";
      $fa{$1}{"alias $ARGV:$."}++;
  };

  close(ARGV) if eof; # this resets the line counter to zero for every input file
};

#dd \%fa;

foreach my $key (sort keys %fa) {
  my $p = 0;
  $p = 1 if keys %{ $fa{$key} } > 1;
  foreach my $k (keys %{ $fa{$key} }) {
    if ($fa{$key}{$k} > 1) {
      $p = 1;
    };
  };
  print join("\n\t", "$key:", (keys %{$fa{$key}}) ), "\n\n" if $p;
};

