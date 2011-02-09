# This is an example script on one of the ways of updating the database.
#
# If it works on your machine, it will open a new terminal and neatly run in
# the background, getting the new replications when they are released. Ctrl+C
# will exit the update script and close the window.
#
# A Tip: Resize the newly opened terminal to the correct width, and height of
# 2 lines

gnome-terminal --title="MusicBrainz MySQL Update" --command="./Update.pl -r"
