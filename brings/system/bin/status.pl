#!/usr/bin/perl

my $peerid=`ipms --offline config Identity.PeerID`; chomp($peerid);
printf "--- # %s\n",$0;
printf "peerid: %s\n",$peerid;
print "status: OK\n";
print  "...\n";

exit $?;
1; # $Source: /my/perl/scriptes/status.pl$

