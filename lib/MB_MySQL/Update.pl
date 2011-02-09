#!/usr/bin/perl

use LWP::UserAgent;
use DBI;

require "Globals.pl";
require "MB_Funcs.pl";
my $version = "2.1";

# FLAGS
my $f_quiet = 0;
my $f_info = 0;
my $f_onlypending = 0;
my $f_keeprunning = 0;
my $f_nonverbose = 0;
my $f_onlytocurrent = 0;
my $f_show_extras = 0;
my $f_skiptorep = 0;
my $f_truncatetables = 0;

# PROCESS FLAGS
foreach $ARG (@ARGV) {
  @parts = split("=", $ARG);
	if($parts[0] eq "-q" || $parts[0] eq "--quiet") {
		$f_quiet = 1;
	} elsif($parts[0] eq "-i" || $parts[0] eq "--info") {
		$f_info = 1;
	} elsif($parts[0] eq "-p" || $parts[0] eq "--onlypending") {
		$f_onlypending = 1;
	} elsif($parts[0] eq "-r" || $parts[0] eq "--keeprunning") {
		$f_keeprunning = 1;
	} elsif($parts[0] eq "-n" || $parts[0] eq "--nonverbose") {
		$f_nonverbose = 1;
	} elsif($parts[0] eq "-s" || $parts[0] eq "--showall") {
		$f_show_extras = 1;
	} elsif($parts[0] eq "-t" || $parts[0] eq "--truncate") {
		$f_truncatetables = 1;
	} elsif($parts[0] eq "-c" || $parts[0] eq "--onlytocurrent") {
		$f_onlytocurrent = 1;
		$f_keeprunning = 1;
	} elsif($parts[0] eq "-g" || $parts[0] eq "--skiptorep") {
		$f_skiptorep = int($parts[1]);
	} elsif($parts[0] eq "-h" || $parts[0] eq "--help") {
		&showhelp();
		exit(0);
	} else {
		die "Unknown option '$parts[0]'\n";
	}
}

sub showhelp {
  print "VERSION: $version\n\n";
  print "-c or --onlytocurrent  Keep updating as many replications as possible until no more replications can\n";
  print "                       be found on the server then quit.\n";
  print "-g=x or --skiptorep=x  Change replication number to 'x'\n";
  print "-h or --help           Show this help.\n";
  print "-i or --info           Only shows the information about the current replication and pending\n";
  print "                       transactions.\n";
  print "-n or --nonverbose     Only print the progress every time a new XID is started. This is to minimise\n";
  print "                       the printing to the console.\n";
  print "-p or --onlypending    Only process pending transactions then quit.\n";
  print "-q or --quiet          Non-verbose. The status of each statement is not printed.\n";
  print "-r or --keeprunning    Keep the script running constantly, automatically checking for new replications\n";
  print "                       every 15 mins (value determined by \$g_rep_chkevery)\n";
  print "-s or --showall        This will show what type of statement (INSERT/UPDATE/DELETE) is being run and\n";
  print "                       how long it takes for the statement to process\n";
  print "-t or --truncate       Force TRUNCATE on Pending and PendindData tables.\n";
}

BEGIN:

# TRUNCATE TABLES
if($f_truncatetables == 1) {
  $sql = "TRUNCATE Pending";
  my $sth = $dbh->prepare($sql);
  $sth->execute;
  $sql = "TRUNCATE PendingData";
  my $sth = $dbh->prepare($sql);
  $sth->execute;
  exit(0);
}

# GET CURRENT REPLICATION AND SCHEMA
$sql = "select * from replication_control";
my $sth = $dbh->prepare($sql);
$sth->execute;
my @row = $sth->fetchrow_array();
my $rep = $row[2];
my $schema = $row[1];

# CHANGE REPLICATION NUMBER
if($f_skiptorep > 0) {
  print "CHANGING REPLICATION NUMBER: $f_skiptorep\n";
  print "Moving ";
  if($rep > $f_skiptorep) {
    print "BACKWARD ";
  } else {
    print "FORWARD ";
  }
  print abs($f_skiptorep - $rep) . " replications.\n";
  
  $dbh->do("UPDATE replication_control SET current_replication_sequence=$f_skiptorep");
  print "Done\n";
  
  exit(0);
}

# FIND IF THERE ARE PENDING TRANSACTIONS
$sql = "SELECT count(*) from Pending";
$sth = $dbh->prepare($sql);
$sth->execute;
@row = $sth->fetchrow_array();
if($f_info) {
	print "\nCurrent replication       : " . ($rep + 1);
	$sql = "SELECT * from replication_control";
	my $sth2 = $dbh->prepare($sql);
	$sth2->execute;
	my @row2 = $sth2->fetchrow_array();
	print "\nLast replication finished : " . &format_sql_date($row2[3]);
	print "\n\nPending transactions      : $row[0]\n\n";
	exit(0);
}

print "\nCurrent replication is $rep\n\n";
$id = int($rep) + 1;
print "Looking for previous pending changes... ";

if($row[0] eq '0' && !$f_info) {
	print "None\n\n";
	if($f_onlypending) {
		exit(0);
	}
	if(!&download($id)) {
		print "\nReplication $id could not be found on the server\n\n";
		exit(0) if(!$f_keeprunning);
		if($f_keeprunning) {
			$wait = $g_rep_chkevery;
			while($wait > 0) {
				print "Trying again in $wait minutes\n";
				sleep(60);
				$wait -= 1;
			}
			goto BEGIN;
		}
	}
	&unzip($id);
	if(&checkNewSchema($rep + 1)) {
	  BEGINSCHEMA:
	  if(!&download_schema($schema + 1)) {
	    print "New screma not available yet.\n";
	    if($f_keeprunning) {
			  $wait = $g_rep_chkevery;
			  while($wait > 0) {
				  print "Trying again in $wait minutes\n";
				  sleep(60);
				  $wait -= 1;
			  }
			  goto BEGINSCHEMA;
		  }
		  exit(0);
	  }
	  &unzip_schema($schema + 1);
	  &run_schema($schema + 1);
	  &clean_sid($schema + 1);
	}
	&load_data($id);
} else {
	print "$row[0] pending\n\n";
	&run_transactions();
}

if($f_keeprunning && !$f_info) {
	goto BEGIN;
}

sub format_sql_date {
	$str = $_[0];
	return substr($str, 8, 2) . ' ' . $g_months[int(substr($str, 5, 2))] . ' ' . substr($str, 0, 4) . ' ' . substr($str, 11, 8);
}

sub run_schema {
  $sid = $_[0];
  system("perl replication/schema-$sid/update.pl");
}

sub clean_sid {
  $sid = $_[0];

	# Clean up. Remove schema files.
	system("rm -f replication/schema-$sid.tar.bz2");
	system("rm -f -r replication/schema-$sid");
}

sub download {
  $id = $_[0];
	print "===== $id =====\n";
	
	# make sure that the file isn't already downloaded
	if(-e "replication/replication-$id.tar.bz2") {
		print localtime() . ": Downloading... Done\n";
  	return 1;
	}

  print localtime() . ": Downloading... ";
  $localfile = "replication/replication-$id.tar.bz2";
  $url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/data/replication/replication-$id.tar.bz2";
  $ua = LWP::UserAgent->new();
  $request = HTTP::Request->new('GET', $url);
  $resp = $ua->request($request, $localfile);
  $found = 0;
  
  use HTTP::Status qw( RC_OK RC_NOT_FOUND RC_NOT_MODIFIED );
  if($resp->code == RC_NOT_FOUND) {
    # file not found
  } elsif($resp->code == RC_OK || $resp->code == RC_NOT_MODIFIED) {
    $found = 1;
  }

  print "Done\n";
  return $found;
}

sub download_schema {
  $sid = $_[0];
	print "DOWNLOADING SCHEMA: $sid\n";
	
	# make sure that the file isn't already downloaded
	if(-e "replication/schema-$sid.tar.bz2") {
		print localtime() . ": Downloading Schema... Done\n";
  	return 1;
	}

  print localtime() . ": Downloading Schema... ";
  $localfile = "replication/schema-$sid.tar.bz2";
  $url = $g_schema_url . "schema-$sid.tar.bz2";
  $ua = LWP::UserAgent->new();
  $request = HTTP::Request->new('GET', $url);
  $resp = $ua->request($request, $localfile);
  $found = 0;
  
  use HTTP::Status qw( RC_OK RC_NOT_FOUND RC_NOT_MODIFIED );
  if($resp->code == RC_NOT_FOUND) {
    # file not found
  } elsif($resp->code == RC_OK || $resp->code == RC_NOT_MODIFIED) {
    $found = 1;
  }

  print "Done\n";
  return $found;
}

sub checkNewSchema {
  $id = $_[0];

  open(SCHEMAFILE, "replication/$id/SCHEMA_SEQUENCE") || die "Could not open 'replication/$id/SCHEMA_SEQUENCE'\n";
  @data = <SCHEMAFILE>;
  chomp($data[0]);
  close(SCHEMAFILE);
  return 0 if($data[0] == $schema);
  return 1;
}

sub unzip {
  $id = $_[0];

  print localtime() . ": Uncompressing... ";
  mkdir("replication/$id");
  system("tar -xjf replication/replication-$id.tar.bz2 -C replication/$id");
  print "Done\n";
  return 1;
}

sub unzip_schema {
  $sid = $_[0];

  print localtime() . ": Uncompressing Schema... ";
  mkdir("replication/schema-$sid");
  system("tar -xjf replication/schema-$sid.tar.bz2 -C replication");
  print "Done\n";
  return 1;
}

sub fmod {
	return 0 if($_[1] == 0);
	$times = int($_[0] / $_[1]);
	return ($_[0] - ($times * $_[1]));
}

sub padzero {
  if($_[0] eq int($_[0])) { return "$_[0].0"; }
  return $_[0];
}

sub round {
	$rem = &fmod($_[0], $_[1]);
	return &padzero($_[0] + ($_[1] - $rem)) if($rem >= ($_[1] * 0.5));
	return &padzero($_[0] - $rem);
}

sub run_transactions {
	# make sure there are transactions in the table
	$sql = "SELECT count(*) from Pending";
	my $sth = $dbh->prepare($sql);
	$sth->execute;
	my @row = $sth->fetchrow_array();
	if($row[0] eq '0') {
		return 0;
	}
	
  $sql = "SELECT Pending.XID, MAX(SeqId) FROM Pending GROUP BY Pending.XID ORDER BY MAX(Pending.SeqId)";
  $sth = $dbh->prepare($sql);
  $sth->execute;

	use Time::HiRes qw( gettimeofday tv_interval );
	my $t1 = [gettimeofday], $t2;
	my $interval;
  my $lastxid = 0;
	my $rows = 0;
	my $strows = 0;

	$temp = $dbh->prepare("SELECT count(*) FROM PendingData");
  $temp->execute;
  @row = $temp->fetchrow_array();
	$total_statements = $row[0];
  $temp->finish;

	my $starttime = time();

	while(@row = $sth->fetchrow_array()) {
		my $XID = $row[0];
		my $maxSeqId = $row[1];
		my $seqId;

		if ($skip_seqid and $maxSeqId <= $skip_seqid) {
			print localtime() . ": Ignoring SeqId #$maxSeqId\n";
			next;
		}

		my $query2 = "SELECT count(*) FROM Pending, PendingData WHERE Pending.SeqId=PendingData.SeqId AND Pending.XID=$XID ORDER BY Pending.SeqId, IsKey DESC";
		my $sth2 = $dbh->prepare($query2);
    $sth2->execute;
    @temprow = $sth2->fetchrow_array();
		my %stmt_type = ( 'i' => 'INSERT', 'u' => 'UPDATE', 'd' => 'DELETE' );
		if($temprow[0] ne "0") {
			my (@row2, $curTuple);
			my $query = "SELECT PendingData.SeqId, Pending.TableName, Pending.Op, PendingData.IsKey, PendingData.Data AS Data FROM Pending, PendingData WHERE Pending.SeqId=PendingData.SeqId AND Pending.XID=$XID ORDER BY Pending.SeqId, IsKey DESC";
			$slave = $dbh->prepare($query);
  		$slave->execute;

  		while(@row2 = $slave->fetchrow_array()) {
				my $temp_time = time();
				if($f_show_extras == 1) {
					print "$stmt_type{$row2[2]} ";
				}
				if (!mirrorCommand($row2[2], $sth, $slave, \@row2, $XID)) {
					die "Mirror command failed.\n";
				}

				if($total_statements != 0) {
					$est = 100 * $strows / $total_statements;
				} else {
					$est = "-";
				}
				$time = time() - $starttime;
				my $stmt_time = time() - $temp_time;
				if(!$f_quiet) {
					if($f_show_extras == 1) {
						print "(" . &formattime($stmt_time) . ") : ";
					}
					if($f_nonverbose) {
						if($lastxid != $XID) {
							printf("XIDs: %5d   Stmts: %5s   est%%: %6s%%   Elapsed: %12s   ETA: %12s\n", $rows, $strows + 1, &round($est, 0.1), &formattime($time), ($est == 0) ? "-" : &formattime($time * (100 - $est) / $est));
						}
					} else {
						printf("XIDs: %5d   Stmts: %5s   est%%: %6s%%   Elapsed: %12s   ETA: %12s\n", $rows, $strows + 1, &round($est, 0.1), &formattime($time), ($est == 0) ? "-" : &formattime($time * (100 - $est) / $est));
					}
				}
				++$strows;
				$dbh->do("DELETE FROM Pending WHERE SeqId=$row2[0]") or warn "\nCould not remove Pending record\n";
				$dbh->do("DELETE FROM PendingData WHERE SeqId=$row2[0]") or warn "\nCould not remove PendingData record\n";
				$lastxid = $XID;
			}
		}
		++$rows;
	}
	if($f_nonverbose) {
		printf("XIDs: %5d   Stmts: %5s   est%%: %6s%%   Elapsed: %12s   ETA: %12s\n", $rows, $strows + 1, &round($est, 0.1), &formattime($time), ($est == 0) ? "-" : &formattime($time * (100 - $est) / $est));
	}

	$temp = $dbh->prepare("SELECT * FROM replication_control");
  $temp->execute;
  @row = $temp->fetchrow_array();
	$nextrep = $row[2];
  $temp->finish;
  
  # update replication id
  &run_sql("UPDATE replication_control SET current_replication_sequence=" . ($rep + 1));
  
  # make sure tables are truncated and ready for next replication.
  # Usually not needed, but just to be safe.
  $temp = $dbh->prepare("TRUNCATE Pending");
  $temp->execute;
  $temp->finish;
  $temp = $dbh->prepare("TRUNCATE PendingData");
  $temp->execute;
  $temp->finish;
	
	# Clean up. Remove old replication
	system("rm -f replication/replication-$nextrep.tar.bz2");
	system("rm -f -r replication/$nextrep");
}

sub load_data {
  $id = $_[0];

	# make sure there are no pending transactions before cleanup
	$temp = $dbh->prepare("SELECT count(*) FROM Pending");
  $temp->execute;
  @row = $temp->fetchrow_array();
  $temp->finish;
	if($row[0] ne '0') {
		return -1;
	}

	# perform cleanup (makes sure there no left over records in the PendingData table)
	$dbh->do("DELETE FROM PendingData");

  if($g_use_login == 1) {
    $g_prog .= " -u $g_db_user --password=$g_db_pass";
  }
  $g_prog .= " < sql/temp.sql";

  # load Pending and PendingData
	print localtime() . ": Loading pending tables... ";
  &run_sql("LOAD DATA LOCAL INFILE 'replication/$id/mbdump/Pending' INTO TABLE Pending");
  &run_sql("LOAD DATA LOCAL INFILE 'replication/$id/mbdump/PendingData' INTO TABLE PendingData");
  close(TEMPSQL);
  system($g_prog);
  print "Done\n";

  # run the pending edits
  print localtime() . ": Processing Transactions...\n";
  &run_transactions();
  print "Finished\n";

  return 1;
}

