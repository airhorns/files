#!/usr/bin/perl

use LWP::UserAgent;
use DBI;

require "Globals.pl";
require "MB_Funcs.pl";
my $version = "1.0";

# FLAGS
my $f_albumid = 1;
my $f_keeprunning = 0;
my $f_stopat = -1;

# PROCESS FLAGS
# EG: $f_albumid = int(&extractVal($_));
foreach $ARG (@ARGV) {
  @parts = split("=", $ARG);
	if($parts[0] eq "-i" || $parts[0] eq "--id") {
		$f_albumid = int($parts[1]);
	} elsif($parts[0] eq "-h" || $parts[0] eq "--help") {
		&downloadcover_showhelp();
		exit(0);
	} elsif($parts[0] eq "-r" || $parts[0] eq "--keeprunning") {
		$f_keeprunning = 1;
	} elsif($parts[0] eq "-s" || $parts[0] eq "--stopat") {
		$f_stopat = int($parts[1]);
	} else {
		die "Unknown option '$parts[0]'\n";
	}
}

sub downloadcover_showhelp {
  print "VERSION: $version\n\n";
  print "-h or --help         Show this help.\n";
  print "-s=x or --stopat=x   Stop when album.id=x\n";
  print "-i=x or --id=x       Download the cover for the album with the album.id=x\n";
}

# find the max album.id
$sql = "select max(id) from album";
my $sth2 = $dbh->prepare($sql);
$sth2->execute;
my @row2 = $sth2->fetchrow_array();
$maxid = int($row2[0]);

BEGIN:

# check that the id is in range
if($f_albumid > $maxid) {
  print "$f_albumid exceeds the max album.id of $maxid\n";
  exit(0);
}

$url = &getcoverurl($f_albumid);
$filename = "$g_cover_path/" . int($f_albumid / 1000) . "/";

# make sure the destination directory exists
if(!(-e $filename)) {
  system("mkdir $filename");
	print localtime() . ": Created directory '$filename'.\n";
}
print localtime() . ": ID " . $f_albumid . ": ";

# download cover
$fullfilename = $filename . $f_albumid . ".jpg";
if(!&downloadcover($url, $fullfilename)) {
  print "(none)";
}

# make sure that its not 807 bytes (amazon customer uploaded image)
$filesize = -s $fullfilename;
if($filesize == 807) {
  system("rm $fullfilename");
  print ", Image Invalid ... Deleted";
}
print "\n";

exit(0) if($f_stopat > -1 && $f_albumid >= $f_stopat);

if($f_keeprunning) {
  ++$f_albumid;
	goto BEGIN;
}

sub getcoverurl {
  $id = $_[0];
  $sql = "select coverarturl from album left join album_amazon_asin on album.id=album_amazon_asin.album where album.id=" . $id;
	my $sth2 = $dbh->prepare($sql);
	$sth2->execute;
	my @row2 = $sth2->fetchrow_array();
	return $row2[0] if(substr($row2[0], 0, 4) eq "http");
	(return "http://ecx.images-amazon.com" . $row2[0]) if($row2[0] ne "");
	return "";
}

sub downloadcover {
  ($url, $filename) = @_;
	
	# make sure that the file isn't already downloaded
	if(-e $filename) {
		print "Already downloaded";
  	return 1;
	}

  $ua = LWP::UserAgent->new();
  $request = HTTP::Request->new('GET', $url);
  $resp = $ua->request($request, $filename);
  $found = 0;
  
  use HTTP::Status qw( RC_OK RC_NOT_FOUND RC_NOT_MODIFIED );
  if($resp->code == RC_NOT_FOUND) {
    print "File could not be found on server";
  } elsif($resp->code == RC_OK || $resp->code == RC_NOT_MODIFIED) {
    print "Downloading... Done";
    $found = 1;
  }

  return $found;
}

