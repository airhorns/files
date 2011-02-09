#####
# This file contain all the global variables that are needed for the setup and
# replication of the MusicBrainz database.
#
# This file must be configured before any other scripts are run.
#####

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MySQL Options
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

$g_prog = 'mysql';                # the command to run MySQL

$g_use_login = 1;                 # Must be set to '1' if you want to use a login for
                                  # MySQL

$g_db_name = 'logdb_development';    # The database name. 'musicbrainz_db' by default.

$g_db_user = 'root';              # The user name for the MySQL login (eg. 'root')

$g_db_pass = '';                  # The password for the MySQL login

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Replication Options
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

$g_rep_chkevery = 15;  # Check for new replications every # minutes
                       # New replications are exported hourly from MusicBrainz
                       
$g_ignore_tables = "moderator_subscribe_artist,moderator_preference,moderator,moderation,moderation_note,votes,stats,currentstat,historicalstat,trm,trmjoin"; # seperate tables names with ','
                       # eg. "trm,trmjoin"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Schema Options
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

$g_schema_url   = 'http://www.chancemedia.com/MB_MySQL/schema/';
                       
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Errors
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

$g_die_on_dupid = 0;   # If a replication entry returns a duplicate ID error
                       # continue (0) or die (1)

$g_die_on_error = 1;   # If a MySQL error occurs when the replication process
                       # is running, this will tell it to ignore (0) or die (1)
                       
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DownloadCover.pl
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

$g_download_new_covers = 0;                   # If this is set to '1' it will download new
                                              # covers from amazon as they become available
                                              # through replications

$g_cover_path = "/var/www/html/MB/covers";    # The path to where the covers are to be stored.

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# LiveStats.pl
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

$g_livestats = 0;       # Use LiveStats.pl
                        # NOTE: You must run 'LiveStats.pl -i -f' first time.

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Misc.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

@g_months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

$dbh = DBI->connect('dbi:mysql:' . $g_db_name, $g_db_user, $g_db_pass);

return 1;

