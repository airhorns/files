#!/usr/bin/perl

#######################################
##
##  This is the LiveStats script, it will
##  work with the replications to deliver
##  real time statistics about the tables.
##
##  You can activate/deactivate it in
##  Globals.pl
##
#######################################

use DBI;

require "Globals.pl";
require "MB_Funcs.pl";
$version = "2.1";

# FLAGS
my $f_init = 0;
my $f_silent = 0;
my $f_fullrefresh = 0;
my $f_count = 0;
my $f_tablename = "";
my $f_action = "";

# PROCESS FLAGS
foreach $ARG (@ARGV) {
  @parts = split("=", $ARG);
	if($parts[0] eq "-i" || $parts[0] eq "--init") {
		$f_init = 1;
	} elsif($parts[0] eq "-s" || $parts[0] eq "--silent") {
		$f_silent = 1;
	} elsif($parts[0] eq "-n" || $parts[0] eq "--name") {
		$f_tablename = $parts[1];
	} elsif($parts[0] eq "-f" || $parts[0] eq "--fullrefresh") {
		$f_fullrefresh = 1;
	} elsif($parts[0] eq "-a" || $parts[0] eq "--action") {
		$f_action = $parts[1];
	} elsif($parts[0] eq "-c" || $parts[0] eq "--count") {
		$f_count = 1;
	} elsif($parts[0] eq "-h" || $parts[0] eq "--help") {
		&showhelp_livestats();
		exit(0);
	} else {
		die "Unknown option '$parts[0]'\n";
	}
}

if($f_init) {
  &init_livestats;
}

if($f_fullrefresh) {
  &count_tables;
}

if($f_count) {
  &count_tables;
}
sub showhelp_livestats {
  print "VERSION: $version\n\n";
  print "-a or --action         The action to perform. See manual for more information.\n";
  print "-h or --help           This help message.\n";
  print "-i or --init           Initialise livestats. You must use -r to refresh the stats.\n";
  print "-r or --refresh        Compleltely reload all the statistics.\n";
  print "-s or --silent         Don't report any messages\n";
}

sub init_livestats {
  @rows = (
    "global.inserts", 0, "",
    "global.updates", 0, "",
    "global.deletes", 0, "",
    "count.all", 0, "",
    "count.album", 0, "",
    "count.album_amazon_asin", 0, "",
    "count.album_cdtoc", 0, "",
    "count.albumjoin", 0, "",
    "count.albummeta", 0, "",
    "count.annotation", 0, "",
    "count.artist", 0, "",
    "count.artistalias", 0, "",
    "count.artist_relation", 0, "",
    "count.artist_tag", 0, "",
    "count.automod_election", 0, "",
    "count.automod_election_vote", 0, "",
    "count.cdtoc", 0, "",
    "count.clientversion", 0, "",
    "count.country", 0, "",
    "count.currentstat", 0, "",
    "count.historicalstat", 0, "",
    "count.l_album_album", 0, "",
    "count.label_tag", 0, "",
    "count.release_tag", 0, "",
    "count.tag", 0, "",
    "count.track_tag", 0, "",
    "count.l_album_artist", 0, "",
    "count.l_album_track", 0, "",
    "count.l_album_url", 0, "",
    "count.l_artist_artist", 0, "",
    "count.l_artist_track", 0, "",
    "count.l_artist_url", 0, "",
    "count.l_track_track", 0, "",
    "count.l_track_url", 0, "",
    "count.l_url_url", 0, "",
    "count.language", 0, "",
    "count.link_attribute", 0, "",
    "count.link_attribute_type", 0, "",
    "count.lt_album_album", 0, "",
    "count.lt_album_artist", 0, "",
    "count.lt_album_track", 0, "",
    "count.lt_album_url", 0, "",
    "count.lt_artist_artist", 0, "",
    "count.lt_artist_track", 0, "",
    "count.lt_artist_url", 0, "",
    "count.lt_track_track", 0, "",
    "count.lt_track_url", 0, "",
    "count.lt_url_url", 0, "",
    "count.moderation_note_closed", 0, "",
    "count.moderation_note_open", 0, "",
    "count.moderation_closed", 0, "",
    "count.moderation_open", 0, "",
    "count.moderator", 0, "",
    "count.moderator_preference", 0, "",
    "count.moderator_subscribe_artist", 0, "",
    "count.Pending", 0, "",
    "count.PendingData", 0, "",
    "count.puid", 0, "",
    "count.puid_stat", 0, "",
    "count.puidjoin", 0, "",
    "count.puidjoin_stat", 0, "",
    "count.release", 0, "",
    "count.replication_control", 0, "",
    "count.script", 0, "",
    "count.script_language", 0, "",
    "count.stats", 0, "",
    "count.track", 0, "",
    "count.trm", 0, "",
    "count.trm_stat", 0, "",
    "count.trmjoin", 0, "",
    "count.trmjoin_stat", 0, "",
    "count.url", 0, "",
    "count.vote_closed", 0, "",
    "count.vote_open", 0, "",
    "count.label", 0, "",
    "count.gid_redirect", 0, "",
    "count.labelalias", 0, "",
    "count.l_album_label", 0, "",
    "count.l_artist_label", 0, "",
    "count.l_label_label", 0, "",
    "count.l_label_track", 0, "",
    "count.l_label_url", 0, "",
    "count.lt_album_label", 0, "",
    "count.lt_artist_label", 0, "",
    "count.lt_label_label", 0, "",
    "count.lt_label_track", 0, "",
    "count.lt_label_url", 0, "",
    "count.moderator_subscribe_label", 0, "",
    "count.artistwords", 0, "",
    "count.labelwords", 0, "",
    "count.trackwords", 0, "",
    "count.albumwords", 0, "",
    "count.wordlist", 0, "",
    "count.mycollection", 0, "",
    "count.mycollection_groups", 0, "",
    "count.mycollection_users", 0, "",
    "count.mycollection_ratings", 0, ""
  );
  
  for($i = 0; $i < @rows; $i += 3) {
    &run_sql("INSERT INTO livestats SET name='".$rows[$i]."', val=".$rows[$i+1].", strval='".$rows[$i+2]."'");
  }
}

sub count_tables {
  $EMPTYSTR = "''";
  @stmts = (
    "count.album", "(SELECT COUNT(*) FROM album)", $EMPTYSTR,
    "count.album_amazon_asin", "(SELECT COUNT(*) FROM album_amazon_asin)", $EMPTYSTR,
    "count.album_cdtoc", "(SELECT COUNT(*) FROM album_cdtoc)", $EMPTYSTR,
    "count.albumjoin", "(SELECT COUNT(*) FROM albumjoin)", $EMPTYSTR,
    "count.albummeta", "(SELECT COUNT(*) FROM albummeta)", $EMPTYSTR,
    "count.annotation", "(SELECT COUNT(*) FROM annotation)", $EMPTYSTR,
    "count.artist", "(SELECT COUNT(*) FROM artist)", $EMPTYSTR,
    "count.artistalias", "(SELECT COUNT(*) FROM artistalias)", $EMPTYSTR,
    "count.artist_relation", "(SELECT COUNT(*) FROM artist_relation)", $EMPTYSTR,
    "count.artist_tag", "(SELECT COUNT(*) FROM artist_tag)", $EMPTYSTR,
    "count.automod_election", "(SELECT COUNT(*) FROM automod_election)", $EMPTYSTR,
    "count.automod_election_vote", "(SELECT COUNT(*) FROM automod_election_vote)", $EMPTYSTR,
    "count.cdtoc", "(SELECT COUNT(*) FROM cdtoc)", $EMPTYSTR,
    "count.clientversion", "(SELECT COUNT(*) FROM clientversion)", $EMPTYSTR,
    "count.country", "(SELECT COUNT(*) FROM country)", $EMPTYSTR,
    "count.currentstat", "(SELECT COUNT(*) FROM currentstat)", $EMPTYSTR,
    "count.historicalstat", "(SELECT COUNT(*) FROM historicalstat)", $EMPTYSTR,
    "count.l_album_album", "(SELECT COUNT(*) FROM l_album_album)", $EMPTYSTR,
    "count.label_tag", "(SELECT COUNT(*) FROM label_tag)", $EMPTYSTR,
    "count.release_tag", "(SELECT COUNT(*) FROM release_tag)", $EMPTYSTR,
    "count.tag", "(SELECT COUNT(*) FROM tag)", $EMPTYSTR,
    "count.track_tag", "(SELECT COUNT(*) FROM track_tag)", $EMPTYSTR,
    "count.l_album_artist", "(SELECT COUNT(*) FROM l_album_artist)", $EMPTYSTR,
    "count.l_album_track", "(SELECT COUNT(*) FROM l_album_track)", $EMPTYSTR,
    "count.l_album_url", "(SELECT COUNT(*) FROM l_album_url)", $EMPTYSTR,
    "count.l_artist_artist", "(SELECT COUNT(*) FROM l_artist_artist)", $EMPTYSTR,
    "count.l_artist_track", "(SELECT COUNT(*) FROM l_artist_track)", $EMPTYSTR,
    "count.l_artist_url", "(SELECT COUNT(*) FROM l_artist_url)", $EMPTYSTR,
    "count.l_track_track", "(SELECT COUNT(*) FROM l_track_track)", $EMPTYSTR,
    "count.l_track_url", "(SELECT COUNT(*) FROM l_track_url)", $EMPTYSTR,
    "count.l_url_url", "(SELECT COUNT(*) FROM l_url_url)", $EMPTYSTR,
    "count.language", "(SELECT COUNT(*) FROM language)", $EMPTYSTR,
    "count.link_attribute", "(SELECT COUNT(*) FROM link_attribute)", $EMPTYSTR,
    "count.link_attribute_type", "(SELECT COUNT(*) FROM link_attribute_type)", $EMPTYSTR,
    "count.lt_album_album", "(SELECT COUNT(*) FROM lt_album_album)", $EMPTYSTR,
    "count.lt_album_artist", "(SELECT COUNT(*) FROM lt_album_artist)", $EMPTYSTR,
    "count.lt_album_track", "(SELECT COUNT(*) FROM lt_album_track)", $EMPTYSTR,
    "count.lt_album_url", "(SELECT COUNT(*) FROM lt_album_url)", $EMPTYSTR,
    "count.lt_artist_artist", "(SELECT COUNT(*) FROM lt_artist_artist)", $EMPTYSTR,
    "count.lt_artist_track", "(SELECT COUNT(*) FROM lt_artist_track)", $EMPTYSTR,
    "count.lt_artist_url", "(SELECT COUNT(*) FROM lt_artist_url)", $EMPTYSTR,
    "count.lt_track_track", "(SELECT COUNT(*) FROM lt_track_track)", $EMPTYSTR,
    "count.lt_track_url", "(SELECT COUNT(*) FROM lt_track_url)", $EMPTYSTR,
    "count.lt_url_url", "(SELECT COUNT(*) FROM lt_url_url)", $EMPTYSTR,
    "count.moderation_note_closed", "(SELECT COUNT(*) FROM moderation_note_closed)", $EMPTYSTR,
    "count.moderation_note_open", "(SELECT COUNT(*) FROM moderation_note_open)", $EMPTYSTR,
    "count.moderation_closed", "(SELECT COUNT(*) FROM moderation_closed)", $EMPTYSTR,
    "count.moderation_open", "(SELECT COUNT(*) FROM moderation_open)", $EMPTYSTR,
    "count.moderator", "(SELECT COUNT(*) FROM moderator)", $EMPTYSTR,
    "count.moderator_preference", "(SELECT COUNT(*) FROM moderator_preference)", $EMPTYSTR,
    "count.moderator_subscribe_artist", "(SELECT COUNT(*) FROM moderator_subscribe_artist)", $EMPTYSTR,
    "count.Pending", "(SELECT COUNT(*) FROM Pending)", $EMPTYSTR,
    "count.PendingData", "(SELECT COUNT(*) FROM PendingData)", $EMPTYSTR,
    "count.puid", "(SELECT COUNT(*) FROM puid)", $EMPTYSTR,
    "count.puid_stat", "(SELECT COUNT(*) FROM puid_stat)", $EMPTYSTR,
    "count.puidjoin", "(SELECT COUNT(*) FROM puidjoin)", $EMPTYSTR,
    "count.puidjoin_stat", "(SELECT COUNT(*) FROM puidjoin_stat)", $EMPTYSTR,
    "count.release", "(SELECT COUNT(*) FROM `release`)", $EMPTYSTR,
    "count.replication_control", "(SELECT COUNT(*) FROM replication_control)", $EMPTYSTR,
    "count.script", "(SELECT COUNT(*) FROM script)", $EMPTYSTR,
    "count.script_language", "(SELECT COUNT(*) FROM script_language)", $EMPTYSTR,
    "count.stats", "(SELECT COUNT(*) FROM stats)", $EMPTYSTR,
    "count.track", "(SELECT COUNT(*) FROM track)", $EMPTYSTR,
    "count.trm", "(SELECT COUNT(*) FROM trm)", $EMPTYSTR,
    "count.trm_stat", "(SELECT COUNT(*) FROM trm_stat)", $EMPTYSTR,
    "count.trmjoin", "(SELECT COUNT(*) FROM trmjoin)", $EMPTYSTR,
    "count.trmjoin_stat", "(SELECT COUNT(*) FROM trmjoin_stat)", $EMPTYSTR,
    "count.url", "(SELECT COUNT(*) FROM url)", $EMPTYSTR,
    "count.vote_closed", "(SELECT COUNT(*) FROM vote_closed)", $EMPTYSTR,
    "count.vote_open", "(SELECT COUNT(*) FROM vote_open)", $EMPTYSTR,
    "count.label", "(SELECT COUNT(*) FROM label)", $EMPTYSTR,
    "count.gid_redirect", "(SELECT COUNT(*) FROM gid_redirect)", $EMPTYSTR,
    "count.labelalias", "(SELECT COUNT(*) FROM labelalias)", $EMPTYSTR,
    "count.l_album_label", "(SELECT COUNT(*) FROM l_album_label)", $EMPTYSTR,
    "count.l_artist_label", "(SELECT COUNT(*) FROM l_artist_label)", $EMPTYSTR,
    "count.l_label_label", "(SELECT COUNT(*) FROM l_label_label)", $EMPTYSTR,
    "count.l_label_track", "(SELECT COUNT(*) FROM l_label_track)", $EMPTYSTR,
    "count.l_label_url", "(SELECT COUNT(*) FROM l_label_url)", $EMPTYSTR,
    "count.lt_album_label", "(SELECT COUNT(*) FROM lt_album_label)", $EMPTYSTR,
    "count.lt_artist_label", "(SELECT COUNT(*) FROM lt_artist_label)", $EMPTYSTR,
    "count.lt_label_label", "(SELECT COUNT(*) FROM lt_label_label)", $EMPTYSTR,
    "count.lt_label_track", "(SELECT COUNT(*) FROM lt_label_track)", $EMPTYSTR,
    "count.lt_label_url", "(SELECT COUNT(*) FROM lt_label_url)", $EMPTYSTR,
    "count.moderator_subscribe_label", "(SELECT COUNT(*) FROM moderator_subscribe_label)", $EMPTYSTR,
    "count.artistwords", "(SELECT COUNT(*) FROM artistwords)", $EMPTYSTR,
    "count.labelwords", "(SELECT COUNT(*) FROM labelwords)", $EMPTYSTR,
    "count.trackwords", "(SELECT COUNT(*) FROM trackwords)", $EMPTYSTR,
    "count.albumwords", "(SELECT COUNT(*) FROM albumwords)", $EMPTYSTR,
    "count.wordlist", "(SELECT COUNT(*) FROM wordlist)", $EMPTYSTR,
    "count.mycollection", "(SELECT COUNT(*) FROM mycollection)", $EMPTYSTR,
    "count.mycollection_groups", "(SELECT COUNT(*) FROM mycollection_groups)", $EMPTYSTR,
    "count.mycollection_users", "(SELECT COUNT(*) FROM mycollection_users)", $EMPTYSTR,
    "count.mycollection_ratings", "(SELECT COUNT(*) FROM mycollection_ratings)", $EMPTYSTR
  );
  for($i = 0; $i < @stmts; $i += 3) {
    $sql = "UPDATE livestats SET val=".$stmts[$i+1].", strval=".$stmts[$i+2]." WHERE name='".$stmts[$i]."'";
    print "$sql\n";
    &run_sql($sql);
  }
  
  # special statements
  $sth = $dbh->prepare("SELECT SUM(val) FROM livestats WHERE name LIKE 'count.%' AND name!='count.all'");
  $sth->execute();
  @result = $sth->fetchrow_array();
  $stmt = "UPDATE livestats SET val=".$result[0]." WHERE name='count.all'";
  print "$stmt\n";
  &run_sql($stmt);
}

