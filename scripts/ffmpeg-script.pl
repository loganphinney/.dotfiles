#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use File::Spec;

my $input_path = $ARGV[0];
unless ($input_path) { die "Usage: $0 <input_file.mkv>\n"; }

print "Enter quality profile value (default=20): ";
chomp( my $qp = <STDIN> );
$qp = 20 unless $qp =~ /^\d+$/;

my @input_files;
if ( -d $input_path ) {
    opendir( my $dh, $input_path )
      or die "Cannot open directory $input_path: $!";

    @input_files = map { File::Spec->catfile( $input_path, $_ ) }
      grep { /\.mkv$/i && -f File::Spec->catfile( $input_path, $_ ) }
      readdir($dh);
    closedir($dh);
}

elsif ( -f $input_path ) { push @input_files, $input_path; }
else { die "Invalid input: $input_path is not a file or directory.\n"; }

( my $output_base = basename($input_path) ) =~ s/\.mkv$//;
my $home = $ENV{'HOME'};

foreach my $file (@input_files) {
    print "Processing: $file\n";

    ( my $output_base = basename($file) ) =~ s/\.mkv$//;
    my $output_file = "$home/Videos/${output_base}-transcoded.mkv";

    my $cmd =
        "ffmpeg -vaapi_device /dev/dri/renderD128 "
      . "-i \"$file\" "
      . "-vf 'format=nv12,hwupload' "
      . "-c:v h264_vaapi -qp $qp "
      . "-map 0 -c:a aac -c:s copy "
      . "\"$output_file\"";

    print "Running: $cmd\n";
    system($cmd) == 0 or warn "Failed to run ffmpeg on $file: $!\n";
    print "Output: $output_file\n";
}
