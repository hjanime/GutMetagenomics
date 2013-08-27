use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;

my $rdpfile = "/home/laurentt/projects/qiime/V6otus/rdp_assigned_taxonomy/qiime_V6Out_rep_set_tax_assignments.txt";

my $otufile = "/home/laurentt/projects/qiime/V6otus/V6_otu_table.txt"; # otus/ley-otuTable.txt";
my $outbase = "/home/laurentt/projects/qiime/V6otus/V6qiimeTaxTable-";
my $om = {}; # otu map
my $sm = {}; # sample hash
my $tl = {}; # tax list
my @reqTax = ('k','p','c','o','f','g');


GetOptions (
	"rdp=s" => \$rdpfile,
	"otu=s" => \$otufile,
	"out=s" => \$outbase,
	); #or die("Usage: perl parseQiimeOutput.pl --rdp <rdpfile> --otu <otu table> --out <out table>");

open RDP , '<', $rdpfile;
open OTU , '<', $otufile;
# open OUT , '>', $outfile;

while (my $line = <RDP>){
	my @flds = split(" ", $line );
	my $otu = $flds[0];
	# print "otu\t$otu\n";
	my @taxa = split(";", $flds[1]);
	for my $tax ( @taxa ){
		if($tax =~ m/^k__/){
			if ($tax =~ m/^k__(\w+)$/){
				# print "Kingdom\t$1\n";
				$om->{$otu}->{'k'} = $1;
				$tl->{'k'}->{$1} = 1;
			} else {
				$om->{$otu}->{'k'} = "unclassified";
			}
		} elsif ($tax =~ m/^p__/){
			if ($tax =~ m/^p__(\w+)$/){
				# print "Phylum\t$1\n";
				$om->{$otu}->{'p'} = $1;
				$tl->{'p'}->{$1} = 1;
			} else {
				$om->{$otu}->{'p'} = "unclassified";
			}
		} elsif ($tax =~ m/^c__/){
			if ($tax =~ m/^c__(\w+)$/){
				# print "Class\t$1\n";
				$om->{$otu}->{'c'} = $1;
				$tl->{'c'}->{$1} = 1;
			} else {
				$om->{$otu}->{'c'} = "unclassified";
			}
		} elsif ($tax =~ m/^o__/){
			if ($tax =~ m/^o__(\w+)$/){
				# print "Order\t$1\n";
				$om->{$otu}->{'o'} = $1;
				$tl->{'o'}->{$1} = 1;
			} else {
				$om->{$otu}->{'o'} = "unclassified";
			}
		} elsif ($tax =~ m/^f__/){
			if ($tax =~ m/^f__(\w+)$/){
				# print "Family\t$1\n";
				$om->{$otu}->{'f'} = $1;
				$tl->{'f'}->{$1} = 1;
			} else {
				$om->{$otu}->{'f'} = "unclassified";
			}
		} elsif ($tax =~ m/^g__/){
			if ($tax =~ m/^g__(\w+)$/){
				# print "Genus\t$1\n";
				$om->{$otu}->{'g'} = $1;
				$tl->{'g'}->{$1} = 1;
			} else {
				$om->{$otu}->{'g'} = "unclassified";
			}
		}
	}
	for my $level ( @reqTax ){
		if (!exists( $om->{$otu}->{$level} )){
			$om->{$otu}->{$level} = "unclassified";
		}
	}
}

for my $tax (@reqTax){
	$tl->{$tax}->{'unclassified'} = 1;
}

# print Dumper($om);
#first line == throw away
<OTU>;
my $sampLine = <OTU>;
print $sampLine."\n";
my @samps = split("\t", $sampLine);
my $i = 0;
for my $samp (@samps){
	chomp $samp;
	print $i++."\t".$samp."\n";
}

while (my $line = <OTU>){
	my @countLine = split("\t", $line);
	my $otu = $countLine[0];
	$i = 1;
	for ($i ; $i < @countLine; $i++){
		if ( $countLine[$i] != "0.0" ){
			# print $i."\t".$countLine[$i]."\n";
			for my $tax (keys (%{$om->{$otu}}) ){
				$sm->{$samps[$i]}->{$tax}->{ $om->{$otu}->{$tax} } += $countLine[$i];
				# print $tax ."\n";
				# if (! exists($sm->{$samps[$i]}->{$tax}->{ $om->{$otu}->{$tax} })){
				# 	$sm->{$samps[$i]}->{$tax}->{ $om->{$otu}->{$tax} } += $countLine[$i];
				# } else {
				# 	$sm->{$samps[$i]}->{$tax}->{ $om->{$otu}->{$tax} } += $countLine[$i];
				# }
			}
		}
	}
}

#remove first element from @samps

shift(@samps);


# print Dumper($sm);

for my $lev ( keys ( %{ $tl } ) ){
	open OUT , '>' , $outbase.$lev.".txt";
	my @taxa = sort ( keys ( %{$tl->{$lev} } ) );
	#print header row
	my $header = "sample";
	for my $tax (@taxa){
		$header .= "\t$tax";
	}
	$header .= "\n";
	print OUT $header;
	for my $samp (@samps){
		my $line = $samp;
		for my $tax (@taxa){
			if ( exists ( $sm->{$samp}->{$lev}->{$tax} ) ){
				$line .= "\t".$sm->{$samp}->{$lev}->{$tax};
			} else {
				$line .= "\t0";
			}
		}
		$line .= "\n";
		print OUT $line;
	}
}



