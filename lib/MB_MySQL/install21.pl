#!/usr/bin/perl

use DBI;

require "Globals.pl";
require "MB_Funcs.pl";

# Check to make sure that v2.0 is already installed.
open(VERSIONFILE, "VERSION") or die "Could not open file 'VERSION'\n";
print "Checking current version is 2.0... ";
chomp(@lines = <VERSIONFILE>);
if($lines[0] eq "MySQL MusicBrainz Database Version: 2.0") {
  print "Correct\n";
} else {
  print "You must have v2.0 installed.\n";
  exit(1);
}
close(VERSIONFILE);

# run new sql
&smartSQL("install21.sql");

# note changes
print "You may now delete the install21* files\n\n";
print "                     ***** NOTE *****\n";
print "Due to new global variables 'Globals.pl' has been replaced,\n";
print "you may need to refill in the necessary values.\n\n";

