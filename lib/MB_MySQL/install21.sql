-- create artistwords
CREATE TABLE artistwords
(
    wordid              INTEGER NOT NULL,
    artistid            INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create labelwords
CREATE TABLE labelwords
(
    wordid              INTEGER NOT NULL,
    labelid             INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create trackwords
CREATE TABLE trackwords
(
    wordid              INTEGER NOT NULL,
    trackid             INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create albumwords
CREATE TABLE albumwords
(
    wordid              INTEGER NOT NULL,
    albumid             INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create wordlist
CREATE TABLE wordlist
(
    id                  INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    word                VARCHAR(255) NOT NULL,
    artistusecount      SMALLINT NOT NULL DEFAULT 0,
    albumusecount       SMALLINT NOT NULL DEFAULT 0,
    trackusecount       SMALLINT NOT NULL DEFAULT 0,
    labelusecount       SMALLINT NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- index wordlist
ALTER TABLE wordlist
ADD INDEX word (word),
ADD INDEX artistusecount (artistusecount),
ADD INDEX albumusecount (albumusecount),
ADD INDEX trackusecount (trackusecount),
ADD INDEX labelusecount (labelusecount);
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

-- alter artist_tag
ALTER TABLE artist_tag
CHANGE weight count INTEGER NOT NULL,
CHANGE ref tag INTEGER NOT NULL;
-- end

-- index link_attribute
ALTER TABLE link_attribute
ADD INDEX link_type (link_type),
ADD INDEX link (link),
ADD INDEX attribute_type (attribute_type);
-- end

-- index l_album_album
ALTER TABLE l_album_album
ADD INDEX link_type (link_type);
-- end

-- index l_album_artist
ALTER TABLE l_album_artist
ADD INDEX link_type (link_type);
-- end

-- index l_album_label
ALTER TABLE l_album_label
ADD INDEX link_type (link_type);
-- end

-- index l_album_track
ALTER TABLE l_album_track
ADD INDEX link_type (link_type);
-- end

-- index l_album_url
ALTER TABLE l_album_url
ADD INDEX link_type (link_type);
-- end

-- index l_artist_artist
ALTER TABLE l_artist_artist
ADD INDEX link_type (link_type);
-- end

-- index l_artist_label
ALTER TABLE l_artist_label
ADD INDEX link_type (link_type);
-- end

-- index l_artist_track
ALTER TABLE l_artist_track
ADD INDEX link_type (link_type);
-- end

-- index l_artist_url
ALTER TABLE l_artist_url
ADD INDEX link_type (link_type);
-- end

-- index l_label_label
ALTER TABLE l_label_label
ADD INDEX link_type (link_type);
-- end

-- index l_label_track
ALTER TABLE l_label_track
ADD INDEX link_type (link_type);
-- end

-- index l_label_url
ALTER TABLE l_label_url
ADD INDEX link_type (link_type);
-- end

-- index l_track_track
ALTER TABLE l_track_track
ADD INDEX link_type (link_type);
-- end

-- index l_track_url
ALTER TABLE l_track_url
ADD INDEX link_type (link_type);
-- end

-- index l_url_url
ALTER TABLE l_url_url
ADD INDEX link_type (link_type);
-- end
-- create livestats
CREATE TABLE IF NOT EXISTS livestats
(
  name VARCHAR(255) PRIMARY KEY,
  val BIGINT DEFAULT 0,
  strval VARCHAR(255)
) ENGINE=InnoDB;
-- end

