#/usr/bin/perl -w

use strict;
use warnings;

my $testfile = "stapDB/grinder-reads.fa";
my $fixedfile = "stapDB/grinder-reads-fixed.fa";

open GR , "< $testfile" or die "could not open $testfile $!";
open FGR, "> $fixedfile" or die "could not open $fixedfile $!";

while (my $line = <GR>){
    chomp $line;
    if ( $line =~ /^>/){
        $line =~ s/\s+/;/g;
    }
    print FGR $line."\n";
}

close GR;

close FGR;
