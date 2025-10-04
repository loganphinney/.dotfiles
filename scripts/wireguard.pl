#!/usr/bin/env perl
use strict;
use warnings;
my $CYAN    = "\033[0;36m";
my $RESET   = "\033[0m";
my $wg_path = '/etc/wireguard';
my $file;

opendir( my $dh, $wg_path ) or die "Cannot open $wg_path: $!";
while ( my $entry = readdir($dh) ) {
    if ( $entry =~ /\.conf$/ ) {
        $file = "$wg_path/$entry";
        last;
    }
}

closedir($dh);
unless ($file) {
    print "No WireGuard files found in $wg_path\n";
    exit 1;
}

print "FOUND: $CYAN$file$RESET\n";
print "UP or DOWN?\n";
my @options = ( 'UP', 'DOWN' );

while (1) {
    print "Select an option:\n  [1] UP\n  [2] DOWN\n";
    chomp( my $input = <STDIN> );

    if ( $input eq '1' || lc($input) eq 'up' ) {
        system( "wg-quick", "up", $file );
        last;
    }

    elsif ( $input eq '2' || lc($input) eq 'down' ) {
        system( "wg-quick", "down", $file );
        last;
    }

    else { print "INVALID. Select UP or DOWN.\n"; }
}
