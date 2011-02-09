-- primary album
ALTER TABLE album
ADD PRIMARY KEY id (id);
-- end

-- primary album_cdtoc
ALTER TABLE album_cdtoc
ADD PRIMARY KEY id (id);
-- end

-- primary albumjoin
ALTER TABLE albumjoin
ADD PRIMARY KEY id (id);
-- end

-- primary albummeta
ALTER TABLE albummeta
ADD PRIMARY KEY id (id);
-- end

-- primary annotation
ALTER TABLE annotation
ADD PRIMARY KEY id (id);
-- end

-- primary artist
ALTER TABLE artist
ADD PRIMARY KEY id (id);
-- end

-- primary artistalias
ALTER TABLE artistalias
ADD PRIMARY KEY id (id);
-- end

-- primary artist_relation
ALTER TABLE artist_relation
ADD PRIMARY KEY id (id);
-- end

-- primary automod_election
ALTER TABLE automod_election
ADD PRIMARY KEY id (id);
-- end

-- primary automod_election_vote
ALTER TABLE automod_election_vote
ADD PRIMARY KEY id (id);
-- end

-- primary cdtoc
ALTER TABLE cdtoc
ADD PRIMARY KEY id (id);
-- end

-- primary clientversion
ALTER TABLE clientversion
ADD PRIMARY KEY id (id);
-- end

-- primary country
ALTER TABLE country
ADD PRIMARY KEY id (id);
-- end

-- primary currentstat
ALTER TABLE currentstat
ADD PRIMARY KEY id (id);
-- end

-- primary historicalstat
ALTER TABLE historicalstat
ADD PRIMARY KEY id (id);
-- end

-- primary l_album_album
ALTER TABLE l_album_album
ADD PRIMARY KEY id (id);
-- end

-- primary l_album_artist
ALTER TABLE l_album_artist
ADD PRIMARY KEY id (id);
-- end

-- primary l_album_track
ALTER TABLE l_album_track
ADD PRIMARY KEY id (id);
-- end

-- primary l_album_url
ALTER TABLE l_album_url
ADD PRIMARY KEY id (id);
-- end

-- primary l_artist_artist
ALTER TABLE l_artist_artist
ADD PRIMARY KEY id (id);
-- end

-- primary l_artist_track
ALTER TABLE l_artist_track
ADD PRIMARY KEY id (id);
-- end

-- primary l_artist_url
ALTER TABLE l_artist_url
ADD PRIMARY KEY id (id);
-- end

-- primary l_track_track
ALTER TABLE l_track_track
ADD PRIMARY KEY id (id);
-- end

-- primary l_track_url
ALTER TABLE l_track_url
ADD PRIMARY KEY id (id);
-- end

-- primary l_url_url
ALTER TABLE l_url_url
ADD PRIMARY KEY id (id);
-- end

-- primary language
ALTER TABLE language
ADD PRIMARY KEY id (id);
-- end

-- primary link_attribute
ALTER TABLE link_attribute
ADD PRIMARY KEY id (id);
-- end

-- primary link_attribute_type
ALTER TABLE link_attribute_type
ADD PRIMARY KEY id (id);
-- end

-- primary lt_album_album
ALTER TABLE lt_album_album
ADD PRIMARY KEY id (id);
-- end

-- primary lt_album_artist
ALTER TABLE lt_album_artist
ADD PRIMARY KEY id (id);
-- end

-- primary lt_album_track
ALTER TABLE lt_album_track
ADD PRIMARY KEY id (id);
-- end

-- primary lt_album_url
ALTER TABLE lt_album_url
ADD PRIMARY KEY id (id);
-- end

-- primary lt_artist_artist
ALTER TABLE lt_artist_artist
ADD PRIMARY KEY id (id);
-- end

-- primary lt_artist_track
ALTER TABLE lt_artist_track
ADD PRIMARY KEY id (id);
-- end

-- primary lt_artist_url
ALTER TABLE lt_artist_url
ADD PRIMARY KEY id (id);
-- end

-- primary lt_track_track
ALTER TABLE lt_track_track
ADD PRIMARY KEY id (id);
-- end

-- primary lt_track_url
ALTER TABLE lt_track_url
ADD PRIMARY KEY id (id);
-- end

-- primary lt_url_url
ALTER TABLE lt_url_url
ADD PRIMARY KEY id (id);
-- end

-- primary moderation_note_open
ALTER TABLE moderation_note_open
ADD PRIMARY KEY id (id);
-- end

-- primary moderation_open
ALTER TABLE moderation_open
ADD PRIMARY KEY id (id);
-- end

-- primary moderator
ALTER TABLE moderator
ADD PRIMARY KEY id (id);
-- end

-- primary moderator_preference
ALTER TABLE moderator_preference
ADD PRIMARY KEY id (id);
-- end

-- primary moderator_subscribe_artist
ALTER TABLE moderator_subscribe_artist
ADD PRIMARY KEY id (id);
-- end

-- primary Pending
ALTER TABLE Pending
ADD PRIMARY KEY SeqId (SeqId);
-- end

-- primary PendingData
ALTER TABLE PendingData
ADD PRIMARY KEY SeqId (SeqId);
-- end

-- primary puid
ALTER TABLE puid
ADD PRIMARY KEY id (id);
-- end

-- primary puid_stat
ALTER TABLE puid_stat
ADD PRIMARY KEY id (id);
-- end

-- primary puidjoin
ALTER TABLE puidjoin
ADD PRIMARY KEY id (id);
-- end

-- primary puidjoin_stat
ALTER TABLE puidjoin_stat
ADD PRIMARY KEY id (id);
-- end

-- primary release
ALTER TABLE `release`
ADD PRIMARY KEY id (id);
-- end

-- primary replication_control
ALTER TABLE replication_control
ADD PRIMARY KEY id (id);
-- end

-- primary script
ALTER TABLE script
ADD PRIMARY KEY id (id);
-- end

-- primary script_language
ALTER TABLE script_language
ADD PRIMARY KEY id (id);
-- end

-- primary stats
ALTER TABLE stats
ADD PRIMARY KEY id (id);
-- end

-- primary track
ALTER TABLE track
ADD PRIMARY KEY id (id);
-- end

-- primary trm
ALTER TABLE trm
ADD PRIMARY KEY id (id);
-- end

-- primary trm_stat
ALTER TABLE trm_stat
ADD PRIMARY KEY id (id);
-- end

-- primary trmjoin
ALTER TABLE trmjoin
ADD PRIMARY KEY id (id);
-- end

-- primary trmjoin_stat
ALTER TABLE trmjoin_stat
ADD PRIMARY KEY id (id);
-- end

-- primary url
ALTER TABLE url
ADD PRIMARY KEY id (id);
-- end

-- primary vote_open
ALTER TABLE vote_open
ADD PRIMARY KEY id (id);
-- end

-- primary label
ALTER TABLE label
ADD PRIMARY KEY id (id);
-- end

-- primary labelalias
ALTER TABLE labelalias
ADD PRIMARY KEY id (id);
-- end

-- primary l_album_label
ALTER TABLE l_album_label
ADD PRIMARY KEY id (id);
-- end

-- primary l_artist_label
ALTER TABLE l_artist_label
ADD PRIMARY KEY id (id);
-- end

-- primary l_label_label
ALTER TABLE l_label_label
ADD PRIMARY KEY id (id);
-- end

-- primary l_label_track
ALTER TABLE l_label_track
ADD PRIMARY KEY id (id);
-- end

-- primary l_label_url
ALTER TABLE l_label_url
ADD PRIMARY KEY id (id);
-- end

-- primary lt_album_label
ALTER TABLE lt_album_label
ADD PRIMARY KEY id (id);
-- end

-- primary lt_artist_label
ALTER TABLE lt_artist_label
ADD PRIMARY KEY id (id);
-- end

-- primary lt_label_label
ALTER TABLE lt_label_label 
ADD PRIMARY KEY id (id);
-- end

-- primary lt_label_track
ALTER TABLE lt_label_track
ADD PRIMARY KEY id (id);
-- end

-- primary lt_label_url
ALTER TABLE lt_label_url
ADD PRIMARY KEY id (id);
-- end

-- primary moderator_subscribe_label
ALTER TABLE moderator_subscribe_label
ADD PRIMARY KEY id (id);
-- end

-- primary wordlist
ALTER TABLE wordlist
ADD PRIMARY KEY id (id);
-- end

-- index album
ALTER TABLE album
ADD INDEX gid (gid),
ADD INDEX name (name),
ADD INDEX artist (artist);
-- end

-- index album_amazon_asin
ALTER TABLE album_amazon_asin
ADD INDEX album (album);
-- end

-- index album_cdtoc
ALTER TABLE album_cdtoc
ADD INDEX album (album);
-- end

-- index albumjoin
ALTER TABLE albumjoin
ADD INDEX album (album),
ADD INDEX track (track);
-- end

-- index artist
ALTER TABLE artist
ADD INDEX gid (gid),
ADD INDEX name (name),
ADD INDEX sortname (sortname);
-- end

-- index artistalias
ALTER TABLE artistalias
ADD INDEX ref (ref),
ADD INDEX name (name);
-- end

-- index artist_relation
ALTER TABLE artist_relation
ADD INDEX artist (artist),
ADD INDEX ref (ref);
-- end

-- index cdtoc
ALTER TABLE cdtoc
ADD INDEX discid (discid),
ADD INDEX freedbid (freedbid);
-- end

-- index l_album_album
ALTER TABLE l_album_album
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_album_artist
ALTER TABLE l_album_artist
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_album_label
ALTER TABLE l_album_label
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_album_track
ALTER TABLE l_album_track
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_album_url
ALTER TABLE l_album_url
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_artist_artist
ALTER TABLE l_artist_artist
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_artist_label
ALTER TABLE l_artist_label
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_artist_track
ALTER TABLE l_artist_track
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_artist_url
ALTER TABLE l_artist_url
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_label_label
ALTER TABLE l_label_label
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_label_track
ALTER TABLE l_label_track
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_label_url
ALTER TABLE l_label_url
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_track_track
ALTER TABLE l_track_track
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_track_url
ALTER TABLE l_track_url
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index l_url_url
ALTER TABLE l_url_url
ADD INDEX link0 (link0),
ADD INDEX link1 (link1),
ADD INDEX link_type (link_type);
-- end

-- index label
ALTER TABLE label
ADD INDEX id (id),
ADD INDEX name (name),
ADD INDEX gid (gid),
ADD INDEX labelcode (labelcode);
-- end

-- index labelalias
ALTER TABLE labelalias
ADD INDEX id (id),
ADD INDEX name (name),
ADD INDEX ref (ref);
-- end

-- index puid
ALTER TABLE puid
ADD INDEX puid (puid);
-- end

-- index puidjoin
ALTER TABLE puidjoin
ADD INDEX puid (puid),
ADD INDEX track (track);
-- end

-- index release
ALTER TABLE `release`
ADD INDEX album (album),
ADD INDEX label (label),
ADD INDEX catno (catno),
ADD INDEX barcode (barcode);
-- end

-- index track
ALTER TABLE track
ADD INDEX gid (gid),
ADD INDEX artist (artist),
ADD INDEX name (name);
-- end

-- index trm
ALTER TABLE trm
ADD INDEX trm (trm);
-- end

-- index trmjoin
ALTER TABLE trmjoin
ADD INDEX trm (trm),
ADD INDEX track (track);
-- end

-- index url
ALTER TABLE url
ADD INDEX gid (gid),
ADD INDEX url (url);
-- end

-- index artist_tag
ALTER TABLE artist_tag
ADD INDEX artist (artist),
ADD INDEX tag (tag);
-- end

-- index label_tag
ALTER TABLE label_tag
ADD INDEX label (label),
ADD INDEX tag (tag);
-- end

-- index release_tag
ALTER TABLE release_tag
ADD INDEX `release` (`release`),
ADD INDEX tag (tag);
-- end

-- index tag
ALTER TABLE tag
ADD INDEX id (id),
ADD INDEX name (name);
-- end

-- index track_tag
ALTER TABLE track_tag
ADD INDEX track (track),
ADD INDEX tag (tag);
-- end

-- index artistwords
ALTER TABLE artistwords
ADD INDEX wordid (wordid),
ADD INDEX artistid (artistid);
-- end

-- index labelwords
ALTER TABLE labelwords
ADD INDEX wordid (wordid),
ADD INDEX labelid (labelid);
-- end

-- index albumwords
ALTER TABLE albumwords
ADD INDEX wordid (wordid),
ADD INDEX albumid (albumid);
-- end

-- index trackwords
ALTER TABLE trackwords
ADD INDEX wordid (wordid),
ADD INDEX trackid (trackid);
-- end

-- index wordlist
ALTER TABLE wordlist
ADD INDEX word (word),
ADD INDEX artistusecount (artistusecount),
ADD INDEX albumusecount (albumusecount),
ADD INDEX trackusecount (trackusecount),
ADD INDEX labelusecount (labelusecount);
-- end

-- index link_attribute
ALTER TABLE link_attribute
ADD INDEX link_type (link_type),
ADD INDEX link (link),
ADD INDEX attribute_type (attribute_type);
-- end

-- index mycollection
ALTER TABLE mycollection
ADD INDEX uidx (uidx),
ADD INDEX gid (gid);
-- end

-- index mycollection_groups
ALTER TABLE mycollection_groups
ADD INDEX uidx (uidx);
-- end

-- index mycollection_ratings
ALTER TABLE mycollection_ratings
ADD INDEX artist_id (artist_id),
ADD INDEX artist_gid (artist_gid),
ADD INDEX album_id (album_id),
ADD INDEX album_gid (album_gid);
-- end

