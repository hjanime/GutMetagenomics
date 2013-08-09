#!/usr/bin/perl -w
#
use strict;

use warnings;


my $taxdb = "rdptest/gg_13_5_taxonomy.txt.gz";

my $RDBres = "rdptest/multiAssignFull.txt" ;

my $outTab = "rdptest/GGaccuracy.txt";

open IN, "< $RDBres";

open OUT, "> $outTab";

my $tot = 0;
open REF, 'zcat rdptest/gg_13_5_taxonomy.txt.gz | ' or die "error opening the taxonomic reference file";   

my @ref = <REF>;
my $rh = {};
for my $e (@ref) {
    chomp $e;
    my $k = $e;
    $k =~ s/^(\d+).*$/$1/;
    $rh->{$k} = $e;
}

my $oflds = "ref\tstart\tstop\tdomain\tdScore\trDomain\tdMatch\tphylum\tpScore\trPhylum\tpMatch\tclass\tcScore\trClass\tcMatch\torder\toScore\trOrder\toMatch\tfamily\tfScore\trFamily\tfMatch\tgenus\tgScore\trGenus\tgMatch\n";

print OUT $oflds;

while (my $line = <IN> ){
    $tot++;
    chomp $line;
    $line =~ s/\t\-\t/\t/g;
    my @flds = split('\t', $line );
    my $ref;
    my $pos1;
    my $pos2;
    my $rfld;
    print "\n".$line."\n";
    if ($flds[0] =~ /reference=(\d+);position=\D*(\d+)\.\.(\d+)/ ){
        $ref = $1;
        $pos1 = $2;
        $pos2 = $3;
    } else {
        die "improper ID \n";
    }
    print "pos1 $pos1\tpos2 $pos2\n";
    ##my $refrow = `zgrep "^$ref\\sk" stapDB/gg_13_5_taxonomy.txt.gz`;
#    my @refrows = grep { /${ref}\sk/ } @ref; 
    my @reff = split(' ', $rh->{$ref});
  
    print "hash lookup\t".$rh->{$ref}."\n";
    
    for my $rfld (@reff){
        $rfld =~ s/;//;
        $rfld =~ s/\w__//;
    }

    print OUT "$ref\t";

    for (my $i = 0 ; $i < @flds; $i++ ){
        print "field $i\t".$flds[$i]."\n";
    }

    if ($pos1 < $pos2 ){
        print OUT "$pos1\t$pos2\t";
    } else {
        print OUT "$pos2\t$pos1\t";
    }
    my $c ;
    if ( @flds == 20 ){
        $c = 2;
    } else {
        $c = 1;
    }
    my $fld = {};

    while ( $flds[$c]){
        $flds[$c] =~ s/\"//g;
        print "c = $c\ttaxlev = ".$flds[$c+1]."\tname = ".$flds[$c]."\tscore = ".$flds[$c+2]."\n";
        $fld->{$flds[$c+1]}->{name} = $flds[$c];
        $fld->{$flds[$c+1]}->{score} = $flds[$c+2];
        $c+= 3;
    }



    if ($fld->{domain}->{name} ){
    #domain
    print OUT $fld->{domain}->{name}."\t";
    #dScore
    print OUT $fld->{domain}->{score}."\t";
    } else {
    print OUT "NA\tNA\t";
    }
    if ($reff[1] ne ''){
    #rDomain
    print OUT $reff[1]."\t";
    } else {
        print "NA";
    }
    #dMatch
    if($reff[1] eq '' || !exists($fld->{domain}->{name})){
        print OUT "NA\t";
    } elsif ($fld->{domain}->{name} eq $reff[1]) {
        print OUT "1\t";
    } else {
        print OUT "0\t";
    }

    if ($fld->{phylum}->{name}){   
   #phylum
    print OUT $fld->{phylum}->{name}."\t";
    #pScore
    print OUT $fld->{phylum}->{score}."\t";
}else {     print OUT "NA\tNA\t";
 }
   if ( $reff[2]ne ''){
    #rPhylum
    print OUT $reff[2]."\t";
    #pMatch
} else {
    print "NA\t";
}
    if($reff[2] eq ''||!exists($fld->{phylum}->{name}) ){
        print OUT "NA\t";
    } elsif ($fld->{phylum}->{name} eq $reff[2]) {
        print OUT "1\t";
    } else {
        print OUT "0\t";
    }

    if ($fld->{class}->{name}){
    #class
    print OUT $fld->{class}->{name}."\t";
    #cScore
    print OUT $fld->{class}->{score}."\t";
} else {
    print OUT "NA\tNA\t";
}
    if ( $reff[3] ne ''){
    #rClass
    print OUT $reff[3]."\t";
} else {
    print OUT "NA\t";
}
    #cMatch
    if($reff[3] eq '' || !exists($fld->{class}->{name})){
        print OUT "NA\t";
    } elsif ($fld->{class}->{name} eq $reff[3]) {
        print OUT "1\t";
    } else {
        print OUT "0\t";
    } 
    
    if($fld->{order}->{name}){
    #order
    print OUT $fld->{order}->{name}."\t";
    #oScore
    print OUT $fld->{order}->{score}."\t";
} else {
    print OUT "NA\tNA\t";
}
    #rOrder
    if ( $reff[4]){
    print OUT $reff[4]."\t";
} else {
    print OUT "NA\t";
}
    #oMatch
    if($reff[4] eq '' || !exists($fld->{order}->{name} )){
        print OUT "NA\t";
    } elsif ($fld->{order}->{name} eq $reff[4]) {
        print OUT "1\t";
    } else {
        print OUT "0\t";
    }

    if($fld->{family}->{name}){
    #family
    print OUT $fld->{family}->{name}."\t";
    #fScore
    print OUT $fld->{family}->{score}."\t";
} else {
    print OUT "NA\tNA\t";
}
    if ( $reff[4] ){ 
#rFamily
    print OUT $reff[4]."\t";
} else {
    print OUT "NA\t";
}
    #fMatch
    if($reff[4] eq '' || !exists($fld->{family}->{name})){
        print OUT "NA\t";
    } elsif ($fld->{family}->{name} eq $reff[4]) {
        print OUT "1\t";
    } else {
        print OUT "0\t";
    }

    if($fld->{genus}->{name}){
    #genus
    print OUT $fld->{genus}->{name}."\t";
    #gScore
    print OUT $fld->{genus}->{score}."\t";
} else {
    print OUT "NA\tNA\t";
}
    if ( $reff[5] ) {
    #rGenus
    print OUT $reff[5]."\t";
} else {
    print OUT "NA\t";
}
    #gMatch
    if($reff[5] eq '' || !exists($fld->{genus}->{name})){
        print OUT "NA\t";
    } elsif ($fld->{genus}->{name} eq $reff[5]) {
        print OUT "1\t";
    } else {
        print OUT "0\n";
    }

}

close IN;
close OUT;


