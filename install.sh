#!/usr/bin/env perl
BEGIN {
    # safe now
    push @INC, '.';
}
use DockerFilePath;

$arg_count = $#ARGV + 1;

if ( $> != 0 ) {
  print "This script must be run as root\n";
  exit (0);
}

if ( $arg_count < 1 ) {
  print "This script must have at least 1 argument\n";
  exit (0);
}

&DockerFilePath::create(\@ARGV);
