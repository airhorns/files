#!/usr/bin/perl

use DBI;

require "Globals.pl";
require "MB_Funcs.pl";
$version = "2.1";

print "Version: $version\n\n";
print "[0] CREATE DATABASE $g_db_name;\n";
print "[1] Create mysql tables\n";
print "[2] Load data into tables\n";
print "[3] Add index fields to tables\n";
print "[4] Drop mysql database (MusicBrainz or MyCollection tables\n\n";

print "Choose option: ";
chomp($option = <STDIN>);

if($option eq "0") { &create_db_stmt(); }  
if($option eq "1") { &create_db(); }  
if($option eq "2") { &load_data(); }
if($option eq "3") { &index_db(); }
if($option eq "4") { &drop_db(); }

sub create_db_stmt {
   print "NOTE: Make sure you have configured the 'Globals.pl' file by opening it in a\n";
   print "text editor. This will execute CREATE DATABASE $g_db_name; You may change\n";
   print "the database name in Globals.pl in \$g_db_name.\n\n";
   print "Continue (y/n): ";
   chomp($continue = <STDIN>);

   if($continue eq "y" || $continue eq "Y") {
     if($g_use_login == 1) {
       $g_prog .= " --local-infile -u $g_db_user --password=$g_db_pass";
     }
     $g_prog .= " < sql/temp.sql";
     open(TEMPSQL, "> sql/temp.sql");
     print TEMPSQL "CREATE DATABASE $g_db_name;\n";
     close TEMPSQL;
     print "\n" . localtime() . ": CREATE DATABASE $g_db_name... ";
     system($g_prog);
     print "Done\n";
   } else {
     print "Canceled\n";
   }
}

sub create_db {
   print "NOTE: Make sure you have configured the 'Globals.pl' file by opening it in a\n";
   print "text editor. This will create all the tables in mysql.\n\n";
   print "Continue (y/n): ";
   chomp($continue = <STDIN>);

   if($continue eq "y" || $continue eq "Y") {
     &smartSQL("sql/create_tables.sql");
     print "Done\n";
   } else {
     print "Canceled\n";
   }
}

sub load_data {
    print "NOTES: In './mbdump' needs to be each file for each table. For example\n";
    print "'./mbdump/stats' will be loaded into the 'stats' table. It will only load\n";
    print "the data into the table that have a data file.\n\n";
    print "Continue (y/n): ";
    chomp($continue = <STDIN>);

    if($continue eq "y" || $continue eq "Y") {
	  my $temp_time = time();
    if($g_use_login == 1) {
      $g_prog .= " --local-infile -u $g_db_user --password=$g_db_pass";
    }
    $g_prog .= " < sql/temp.sql";
    opendir(DIR, "mbdump") || die "Can't open ./mbdump: $!";
    @files = sort(grep { $_ ne '.' and $_ ne '..' } readdir(DIR));
    $count = @files;
    $i = 1;
    foreach my $file (@files) {
      my $t1 = time();
  		$table = $file;
  		if($table eq "blank.file") {
  			next;
  		}
  		if($table eq "album") {
        &fixAlbumData();
        $t1 = time();
        $file = "album2";
        $table = "album";
      }
      open(TEMPSQL, "> sql/temp.sql");
      print TEMPSQL "USE $g_db_name;\nLOAD DATA LOCAL INFILE 'mbdump/$file' INTO TABLE `$table`\n";
      print TEMPSQL "FIELDS TERMINATED BY '\\t' ENCLOSED BY '' ESCAPED BY '\\\\'\n";
      print TEMPSQL "LINES TERMINATED BY '\\n' STARTING BY '';";
      close TEMPSQL;
      print "\n" . localtime() . ": Loading data into '$file' ($i of $count)...\n";
      system($g_prog);
  	  my $t2 = time();
      print "Done (" . &formattime($t2 - $t1) . ")\n";
  		++$i;
		}
    closedir DIR;
	  my $t2 = time();
    print "\nComplete (" . &formattime($t2 - $temp_time) . ")\n";
   }
}

sub index_db {
  print "This will add the index and primary key fields to all tables. This can only be\n";
  print "run once AFTER all the tables have been fully loaded.\n\nContinue (y/n): ";
  chomp($continue = <STDIN>);

  if($continue eq "y" || $continue eq "Y") {
    &smartSQL("sql/index.sql");
    print "Done\n";
  } else {
    print "Canceled\n";
  }
}

sub drop_db {
  print "Are you sure you want to proceed to the delete options.\n\n";
  print "Continue (y/n): ";
  chomp($continue = <STDIN>);

  if($continue eq "y" || $continue eq "Y") {
    print "\nDo you want to...\n";
    print "[1] Delete only MusicBrainz tables.\n";
    print "[2] Delete only MyCollection tables.\n";
    print "[3] PHYSICAL 'DROP'. THE ENTIRE DATABASE WILL BE REMOVED.\n";
    print "Choose option: ";
    chomp($option = <STDIN>);
    
    if($option eq "1") {
      &smartSQL("sql/drop_db.sql");
    } elsif($option eq "2") {
      &smartSQL("sql/dropmc_db.sql");
    } elsif($option eq "3") {
      &run_sql("DROP DATABASE $g_db_name");
    }
    
    print "Done\n";
  } else {
    print "Canceled\n";
  }
}

sub fixAlbumData {
	$file = "mbdump/album";
	my $count = 0;
	print "\nConverting album data...\n";
  my $time1 = time();
	open(ALBUM, $file);
	open(ALBUM_OUT, ">mbdump/album2");
	while(defined($line = <ALBUM>)) {
	  chomp($line);
	  @cols = split("\t", $line);
	  $cols[5] = &procAttributes($cols[5]);
	  $line = join("\t", @cols);
	  print ALBUM_OUT $line . "\n";
    ++$count;
	}
	close(ALBUM);
	close(ALBUM_OUT);
  my $time2 = time();
	print "Done (" . $count . " records processed, " . &formattime($time2 - $time1) . ")\n";
	return;
}

