-- create album
CREATE TABLE IF NOT EXISTS album
(
    id                  INTEGER NOT NULL,
    artist              INTEGER NOT NULL, -- references artist
    name                VARCHAR(255) NOT NULL,
    gid                 CHAR(36) NOT NULL,
    modpending          INTEGER DEFAULT 0,
    attributes          INTEGER DEFAULT 0,
    page                INTEGER NOT NULL,
    language            INTEGER, -- references language
    script              INTEGER, -- references script
    modpending_lang     INTEGER,
    quality             SMALLINT DEFAULT -1,
    modpending_qual     INTEGER DEFAULT 0
) ENGINE = InnoDB;
-- end
 
-- create album_amazon_asin
CREATE TABLE IF NOT EXISTS album_amazon_asin
(
    album               INTEGER NOT NULL, -- references album
    asin                CHAR(10),
    coverarturl         VARCHAR(255),
    lastupdate          TIMESTAMP DEFAULT NOW() -- CHANGE: "TIMESTAMP WITH TIME ZONE DEFAULT NOW()"
) ENGINE = InnoDB;
-- end

-- create album_cdtoc
CREATE TABLE IF NOT EXISTS album_cdtoc
(
    id                  INTEGER NOT NULL,
    album               INTEGER NOT NULL,
    cdtoc               INTEGER NOT NULL,
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end
 
-- create albumjoin
CREATE TABLE IF NOT EXISTS albumjoin
(
    id                  INTEGER NOT NULL,
    album               INTEGER NOT NULL, -- references album
    track               INTEGER NOT NULL, -- references track
    sequence            INTEGER NOT NULL,
    modpending          INTEGER DEFAULT 0
) ENGINE = InnoDB;
-- end
 
-- create albummeta
CREATE TABLE IF NOT EXISTS albummeta
(
    id                  INTEGER NOT NULL,
    tracks              INTEGER DEFAULT 0,
    discids             INTEGER DEFAULT 0,
    trmids              INTEGER DEFAULT 0,
    puids               INTEGER DEFAULT 0,
    firstreleasedate    CHAR(10),
    asin                CHAR(10),
    coverarturl         VARCHAR(255)
) ENGINE = InnoDB;
-- end
 
-- create annotation
CREATE TABLE IF NOT EXISTS annotation
(
    id                  INTEGER NOT NULL,
    moderator           INTEGER NOT NULL, -- references moderator
    type                SMALLINT NOT NULL,
    rowid               INTEGER NOT NULL, -- conditional reference
    text                TEXT,
    changelog           VARCHAR(255),
    created             TIMESTAMP DEFAULT NOW(), -- CHANGE: "TIMESTAMP WITH TIME ZONE DEFAULT NOW()"
    moderation          INTEGER NOT NULL DEFAULT 0,
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create artist
CREATE TABLE IF NOT EXISTS artist
(
    id                  INTEGER NOT NULL,
    name                VARCHAR(255) NOT NULL,
    gid                 CHAR(36) NOT NULL,
    modpending          INTEGER DEFAULT 0,
    sortname            VARCHAR(255) NOT NULL,
    page                INTEGER NOT NULL,
    resolution          VARCHAR(64),
    begindate           CHAR(10),
    enddate             CHAR(10),
    type                SMALLINT,
    quality             SMALLINT DEFAULT -1,
    modpending_qual     INTEGER DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create artistalias
CREATE TABLE IF NOT EXISTS artistalias
(
    id                  INTEGER NOT NULL,
    ref                 INTEGER NOT NULL, -- references artist
    name                VARCHAR(255) NOT NULL,
    timesused           INTEGER DEFAULT 0,
    modpending          INTEGER DEFAULT 0,
    lastused            TIMESTAMP -- CHANGE: "TIMESTAMP WITH TIME ZONE"
) ENGINE = InnoDB;
-- end

-- create artist_relation
CREATE TABLE IF NOT EXISTS artist_relation
(
    id                  INTEGER NOT NULL,
    artist              INTEGER NOT NULL, -- references artist
    ref                 INTEGER NOT NULL, -- references artist
    weight              INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create artist_tag
CREATE TABLE IF NOT EXISTS artist_tag
(
    artist              INTEGER NOT NULL,
    tag                 INTEGER NOT NULL,
    count               INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create automod_election
CREATE TABLE IF NOT EXISTS automod_election
(
    id                  INTEGER NOT NULL,
    candidate           INTEGER NOT NULL,
    proposer            INTEGER NOT NULL,
    seconder_1          INTEGER,
    seconder_2          INTEGER,
    status              SET('1','2','3','4','5','6') NOT NULL DEFAULT '1',
        -- CHANGE: "CONSTRAINT automod_election_chk1 CHECK (status IN (1,2,3,4,5,6)),"
        -- 1 : has proposer
        -- 2 : has seconder_1
        -- 3 : has seconder_2 (voting open)
        -- 4 : accepted!
        -- 5 : rejected
        -- 6 : cancelled (by proposer)
    yesvotes            INTEGER NOT NULL DEFAULT 0,
    novotes             INTEGER NOT NULL DEFAULT 0,
    proposetime         TIMESTAMP NOT NULL DEFAULT NOW(), -- CHANGE: " WITH TIME ZONE"
    opentime            TIMESTAMP, -- CHANGE: " WITH TIME ZONE"
    closetime           TIMESTAMP  -- CHANGE: " WITH TIME ZONE"
) ENGINE = InnoDB;
-- end

-- create automod_election_vote
CREATE TABLE IF NOT EXISTS automod_election_vote
(
    id                  INTEGER NOT NULL,
    automod_election    INTEGER NOT NULL,
    voter               INTEGER NOT NULL,
    vote                SET('-1','0','1') NOT NULL,
        -- CHANGE: "CONSTRAINT automod_election_vote_chk1 CHECK (vote IN (-1,0,1)),"
    votetime            TIMESTAMP NOT NULL DEFAULT NOW() -- CHANGE: " WITH TIME ZONE"
) ENGINE = InnoDB;
-- end

-- create cdtoc
CREATE TABLE IF NOT EXISTS cdtoc
(
    id                  INTEGER NOT NULL,
    discid              CHAR(28) NOT NULL,
    freedbid            CHAR(8) NOT NULL,
    trackcount          INTEGER NOT NULL,
    leadoutoffset       INTEGER NOT NULL,
    trackoffset         INTEGER NOT NULL, -- CHANGE: "INTEGER[]"
    degraded            BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE = InnoDB;
-- end

-- create clientversion
CREATE TABLE IF NOT EXISTS clientversion
(
    id                  INTEGER NOT NULL,
    version             VARCHAR(64) NOT NULL
) ENGINE = InnoDB;
-- end

-- create country
CREATE TABLE IF NOT EXISTS country
(
    id                  INTEGER NOT NULL,
    isocode             VARCHAR(2) NOT NULL,
    name                VARCHAR(100) NOT NULL
) ENGINE = InnoDB;
-- end

-- create currentstat
CREATE TABLE IF NOT EXISTS currentstat
(
    id                  INTEGER NOT NULL,
    name                VARCHAR(100) NOT NULL,
    value               INTEGER NOT NULL,
    lastupdated         TIMESTAMP -- CHANGE: " WITH TIME ZONE"
) ENGINE = InnoDB;
-- end

-- create historicalstat
CREATE TABLE IF NOT EXISTS historicalstat
(
    id                  INTEGER NOT NULL,
    name                VARCHAR(100) NOT NULL,
    value               INTEGER NOT NULL,
    snapshotdate        DATE NOT NULL
) ENGINE = InnoDB;
-- end

-- create l_album_album
CREATE TABLE IF NOT EXISTS l_album_album
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references album
    link1               INTEGER NOT NULL DEFAULT 0, -- references album
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_album_album
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create label_tag
CREATE TABLE IF NOT EXISTS label_tag
(
    label               INTEGER NOT NULL,
    tag                 INTEGER NOT NULL,
    count               INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create release_tag
CREATE TABLE IF NOT EXISTS release_tag
(
    `release`           INTEGER NOT NULL,
    tag                 INTEGER NOT NULL,
    count               INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create tag
CREATE TABLE IF NOT EXISTS tag
(
    id                  INTEGER NOT NULL,
    name                VARCHAR(255) NOT NULL,
    refcount            INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create track_tag
CREATE TABLE IF NOT EXISTS track_tag
(
    track               INTEGER NOT NULL,
    tag                 INTEGER NOT NULL,
    count               INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create l_album_artist
CREATE TABLE IF NOT EXISTS l_album_artist
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references album
    link1               INTEGER NOT NULL DEFAULT 0, -- references artist
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_album_artist
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_album_track
CREATE TABLE IF NOT EXISTS l_album_track
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references album
    link1               INTEGER NOT NULL DEFAULT 0, -- references track
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_album_track
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_album_url
CREATE TABLE IF NOT EXISTS l_album_url
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references album
    link1               INTEGER NOT NULL DEFAULT 0, -- references url
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_album_url
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_artist_artist
CREATE TABLE IF NOT EXISTS l_artist_artist
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references artist
    link1               INTEGER NOT NULL DEFAULT 0, -- references artist
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_artist_artist
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_artist_track
CREATE TABLE IF NOT EXISTS l_artist_track
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references artist
    link1               INTEGER NOT NULL DEFAULT 0, -- references track
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_artist_track
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_artist_url
CREATE TABLE IF NOT EXISTS l_artist_url
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references artist
    link1               INTEGER NOT NULL DEFAULT 0, -- references url
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_artist_url
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_track_track
CREATE TABLE IF NOT EXISTS l_track_track
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references track
    link1               INTEGER NOT NULL DEFAULT 0, -- references track
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_track_track
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_track_url
CREATE TABLE IF NOT EXISTS l_track_url
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references track
    link1               INTEGER NOT NULL DEFAULT 0, -- references url
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_track_url
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_url_url
CREATE TABLE IF NOT EXISTS l_url_url
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references track
    link1               INTEGER NOT NULL DEFAULT 0, -- references url
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_track_url
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create language
CREATE TABLE IF NOT EXISTS language
(
     id                 INTEGER NOT NULL,
     isocode_3t         CHAR(3) NOT NULL, -- ISO 639-2 (T)
     isocode_3b         CHAR(3) NOT NULL, -- ISO 639-2 (B)
     isocode_2          CHAR(2), -- ISO 639
     name               VARCHAR(100) NOT NULL,
     french_name        VARCHAR(100) NOT NULL,
     frequency          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create link_attribute
CREATE TABLE IF NOT EXISTS link_attribute
(
    id                  INTEGER NOT NULL,
    attribute_type      INTEGER NOT NULL DEFAULT 0, -- references link_attribute_type
    link                INTEGER NOT NULL DEFAULT 0, -- references l_<ent>_<ent> without FK
    link_type           VARCHAR(32) NOT NULL DEFAULT '' -- indicates which l_ table to refer to
) ENGINE = InnoDB;
-- end

-- create link_attribute_type
CREATE TABLE IF NOT EXISTS link_attribute_type
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_album_album
CREATE TABLE IF NOT EXISTS lt_album_album
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_album_artist
CREATE TABLE IF NOT EXISTS lt_album_artist
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_album_track
CREATE TABLE IF NOT EXISTS lt_album_track
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_album_url
CREATE TABLE IF NOT EXISTS lt_album_url
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_artist_artist
CREATE TABLE IF NOT EXISTS lt_artist_artist
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_artist_track
CREATE TABLE IF NOT EXISTS lt_artist_track
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_artist_url
CREATE TABLE IF NOT EXISTS lt_artist_url
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_track_track
CREATE TABLE IF NOT EXISTS lt_track_track
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_track_url
CREATE TABLE IF NOT EXISTS lt_track_url
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_url_url
CREATE TABLE IF NOT EXISTS lt_url_url
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create moderation_note_closed
CREATE TABLE IF NOT EXISTS moderation_note_closed
(
    id                  INTEGER NOT NULL,
    moderation          INTEGER NOT NULL,
    moderator           INTEGER NOT NULL,
    text                TEXT NOT NULL,
    notetime        TIMESTAMP DEFAULT NOW() -- CHANGE: " WITH TIME ZONE"
) ENGINE = InnoDB;
-- end

-- create moderation_note_open
CREATE TABLE IF NOT EXISTS moderation_note_open
(
    id                  INTEGER NOT NULL,
    moderation          INTEGER NOT NULL,
    moderator           INTEGER NOT NULL,
    text                TEXT NOT NULL,
    notetime        TIMESTAMP DEFAULT NOW() -- CHANGE: " WITH TIME ZONE"
) ENGINE = InnoDB;
-- end

-- create moderation_closed
CREATE TABLE IF NOT EXISTS moderation_closed
(
    id                  INTEGER NOT NULL,
    artist              INTEGER NOT NULL, -- references artist
    moderator           INTEGER NOT NULL, -- references moderator
    tab                 VARCHAR(32) NOT NULL,
    col                 VARCHAR(64) NOT NULL,
    type                SMALLINT NOT NULL,
    status              SMALLINT NOT NULL,
    rowid               INTEGER NOT NULL,
    prevvalue           VARCHAR(255) NOT NULL,
    newvalue            TEXT NOT NULL,
    yesvotes            INTEGER DEFAULT 0,
    novotes             INTEGER DEFAULT 0,
    depmod              INTEGER DEFAULT 0,
    automod             SMALLINT DEFAULT 0,
    opentime            TIMESTAMP DEFAULT NOW(), -- CHANGE: " WITH TIME ZONE"
    closetime           TIMESTAMP, -- CHANGE: " WITH TIME ZONE"
    expiretime          TIMESTAMP NOT NULL, -- CHANGE: " WITH TIME ZONE"
    language            INTEGER -- references language
) ENGINE = InnoDB;
-- end

-- create moderation_open
CREATE TABLE IF NOT EXISTS moderation_open
(
    id                  INTEGER NOT NULL,
    artist              INTEGER NOT NULL, -- references artist
    moderator           INTEGER NOT NULL, -- references moderator
    tab                 VARCHAR(32) NOT NULL,
    col                 VARCHAR(64) NOT NULL,
    type                SMALLINT NOT NULL,
    status              SMALLINT NOT NULL,
    rowid               INTEGER NOT NULL,
    prevvalue           VARCHAR(255) NOT NULL,
    newvalue            TEXT NOT NULL,
    yesvotes            INTEGER DEFAULT 0,
    novotes             INTEGER DEFAULT 0,
    depmod              INTEGER DEFAULT 0,
    automod             SMALLINT DEFAULT 0,
    opentime            TIMESTAMP DEFAULT NOW(), -- CHANGE: " WITH TIME ZONE"
    closetime           TIMESTAMP, -- CHANGE: " WITH TIME ZONE"
    expiretime          TIMESTAMP NOT NULL, -- CHANGE: " WITH TIME ZONE"
    language            INTEGER -- references language
) ENGINE = InnoDB;
-- end

-- create moderator
CREATE TABLE IF NOT EXISTS moderator
(
    id                  INTEGER NOT NULL,
    name                VARCHAR(64) NOT NULL,
    password            VARCHAR(64) NOT NULL,
    privs               INTEGER DEFAULT 0,
    modsaccepted        INTEGER DEFAULT 0,
    modsrejected        INTEGER DEFAULT 0,
    email               VARCHAR(64) DEFAULT NULL,
    weburl              VARCHAR(255) DEFAULT NULL,
    bio                 TEXT DEFAULT NULL,
    membersince         TIMESTAMP DEFAULT NOW(), -- CHANGE: " WITH TIME ZONE"
    emailconfirmdate    TIMESTAMP, -- CHANGE: " WITH TIME ZONE"
    lastlogindate       TIMESTAMP, -- CHANGE: " WITH TIME ZONE"
    automodsaccepted    INTEGER DEFAULT 0,
    modsfailed          INTEGER DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create moderator_preference
CREATE TABLE IF NOT EXISTS moderator_preference
(
    id                  INTEGER NOT NULL,
    moderator           INTEGER NOT NULL, -- references moderator
    name                VARCHAR(50) NOT NULL,
    value               VARCHAR(100) NOT NULL
) ENGINE = InnoDB;
-- end

-- create moderator_subscribe_artist
CREATE TABLE IF NOT EXISTS moderator_subscribe_artist
(
    id                  INTEGER NOT NULL,
    moderator           INTEGER NOT NULL, -- references moderator
    artist              INTEGER NOT NULL, -- weakly references artist
    lastmodsent         INTEGER NOT NULL, -- weakly references moderation
    deletedbymod        INTEGER NOT NULL DEFAULT 0, -- weakly references moderation
    mergedbymod         INTEGER NOT NULL DEFAULT 0 -- weakly references moderation
) ENGINE = InnoDB;
-- end

-- create Pending
CREATE TABLE IF NOT EXISTS Pending
(
    SeqId               INTEGER NOT NULL,
    TableName           VARCHAR(255) NOT NULL, -- CHANGE: "VARCHAR"
    Op                  VARCHAR(1), -- CHANGE: "CHARACTER"
    XID                 INT4 NOT NULL
) ENGINE = InnoDB;
-- end

-- create PendingData
CREATE TABLE IF NOT EXISTS PendingData
(
    SeqId               INT4 NOT NULL,
    IsKey               BOOL NOT NULL,
    Data                TEXT -- CHANGE: "VARCHAR"
) ENGINE = InnoDB;
-- end

-- create puid
CREATE TABLE IF NOT EXISTS puid
(
    id                  INTEGER NOT NULL,
    puid                CHAR(36) NOT NULL,
    lookupcount         INTEGER NOT NULL DEFAULT 0, -- updated via trigger
    version             INTEGER NOT NULL -- references clientversion
) ENGINE = InnoDB;
-- end

-- create puid_stat
CREATE TABLE IF NOT EXISTS puid_stat
(
    id                  INTEGER NOT NULL,
    puid_id             INTEGER NOT NULL, -- references puid
    month_id            INTEGER NOT NULL,
    lookupcount         INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create puidjoin
CREATE TABLE IF NOT EXISTS puidjoin
(
    id                  INTEGER NOT NULL,
    puid                INTEGER NOT NULL, -- references puid
    track               INTEGER NOT NULL, -- references track
    usecount            INTEGER DEFAULT 0 -- updated via trigger
) ENGINE = InnoDB;
-- end

-- create puidjoin_stat
CREATE TABLE IF NOT EXISTS puidjoin_stat
(
    id                  INTEGER NOT NULL,
    puidjoin_id         INTEGER NOT NULL, -- references puidjoin
    month_id            INTEGER NOT NULL,
    usecount            INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create release
CREATE TABLE IF NOT EXISTS `release`
(
    id                  INTEGER NOT NULL,
    album               INTEGER NOT NULL, -- references album
    country             INTEGER NOT NULL, -- references country
    releasedate         CHAR(10) NOT NULL,
    modpending          INTEGER DEFAULT 0,
    label               INTEGER,          -- references label
    catno               VARCHAR(255),
    barcode             VARCHAR(255),
    format              SMALLINT
) ENGINE = InnoDB;
-- end

-- create replication_control
CREATE TABLE IF NOT EXISTS replication_control
(
    id                              INTEGER NOT NULL,
    current_schema_sequence         INTEGER NOT NULL,
    current_replication_sequence    INTEGER,
    last_replication_date           TIMESTAMP -- CHANGE: " WITH TIME ZONE"
) ENGINE = InnoDB;
-- end

-- create script
CREATE TABLE IF NOT EXISTS script
(
     id                 INTEGER NOT NULL,
     isocode            CHAR(4) NOT NULL, -- ISO 15924
     isonumber          CHAR(3) NOT NULL, -- ISO 15924
     name               VARCHAR(100) NOT NULL,
     french_name        VARCHAR(100) NOT NULL,
     frequency          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create script_language
CREATE TABLE IF NOT EXISTS script_language
(
     id                 INTEGER NOT NULL,
     script             INTEGER,
     language           INTEGER NOT NULL,
     frequency          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create stats
CREATE TABLE IF NOT EXISTS stats
(
    id                  INTEGER NOT NULL,
    artists             INTEGER NOT NULL,
    albums              INTEGER NOT NULL,
    tracks              INTEGER NOT NULL,
    discids             INTEGER NOT NULL,
    trmids              INTEGER NOT NULL,
    moderations         INTEGER NOT NULL,
    votes               INTEGER NOT NULL,
    moderators          INTEGER NOT NULL,
    timestamp           DATE NOT NULL
) ENGINE = InnoDB;
-- end

-- create track
CREATE TABLE IF NOT EXISTS track
(
    id                  INTEGER NOT NULL,
    artist              INTEGER NOT NULL, -- references artist
    name                VARCHAR(255) NOT NULL,
    gid                 CHAR(36) NOT NULL,
    length              INTEGER DEFAULT 0,
    year                INTEGER DEFAULT 0,
    modpending          INTEGER DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create trm
CREATE TABLE IF NOT EXISTS trm
(
    id                  INTEGER NOT NULL,
    trm                 CHAR(36) NOT NULL,
    lookupcount         INTEGER NOT NULL DEFAULT 0, -- updated via trigger
    version             INTEGER NOT NULL -- references clientversion
) ENGINE = InnoDB;
-- end

-- create trm_stat
CREATE TABLE IF NOT EXISTS trm_stat
(
    id                  INTEGER NOT NULL,
    trm_id              INTEGER NOT NULL, -- references trm
    month_id            INTEGER NOT NULL,
    lookupcount         INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create trmjoin
CREATE TABLE IF NOT EXISTS trmjoin
(
    id                  INTEGER NOT NULL,
    trm                 INTEGER NOT NULL, -- references trm
    track               INTEGER NOT NULL, -- references track
    usecount            INTEGER DEFAULT 0 -- updated via trigger
) ENGINE = InnoDB;
-- end

-- create trmjoin_stat
CREATE TABLE IF NOT EXISTS trmjoin_stat
(
    id                  INTEGER NOT NULL,
    trmjoin_id          INTEGER NOT NULL, -- references trmjoin
    month_id            INTEGER NOT NULL,
    usecount            INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create url
CREATE TABLE IF NOT EXISTS url
(
    id                  INTEGER NOT NULL,
    gid                 CHAR(36) NOT NULL,
    url                 VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    refcount            INTEGER NOT NULL DEFAULT 0,
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create vote_closed
CREATE TABLE IF NOT EXISTS vote_closed
(
    id                  INTEGER NOT NULL,
    moderator           INTEGER NOT NULL, -- references moderator
    moderation          INTEGER NOT NULL, -- references moderation
    vote                SMALLINT NOT NULL,
    votetime            TIMESTAMP DEFAULT NOW(), -- CHANGE: " WITH TIME ZONE"
    superseded          BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE = InnoDB;
-- end

-- create vote_open
CREATE TABLE IF NOT EXISTS vote_open
(
    id                  INTEGER NOT NULL,
    moderator           INTEGER NOT NULL, -- references moderator
    moderation          INTEGER NOT NULL, -- references moderation
    vote                SMALLINT NOT NULL,
    votetime            TIMESTAMP DEFAULT NOW(), -- CHANGE: " WITH TIME ZONE"
    superseded          BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE = InnoDB;
-- end

-- create label
CREATE TABLE IF NOT EXISTS label
(
    id                  INTEGER NOT NULL,
    name                VARCHAR(255) NOT NULL,
    gid                 CHAR(36) NOT NULL,
    modpending          INTEGER DEFAULT 0,
    labelcode           INTEGER,
    sortname            VARCHAR(255) NOT NULL,
    country             INTEGER, -- references country
    page                INTEGER NOT NULL,
    resolution          VARCHAR(64),
    begindate           CHAR(10),
    enddate             CHAR(10),
    type                SMALLINT
) ENGINE = InnoDB;
-- end

-- create gid_redirect
CREATE TABLE IF NOT EXISTS gid_redirect
(
    gid                 CHAR(36) NOT NULL,
    newid               INTEGER NOT NULL,
    tbl                 SMALLINT NOT NULL
) ENGINE = InnoDB;
-- end

-- create labelalias
CREATE TABLE IF NOT EXISTS labelalias
(
    id                  INTEGER NOT NULL,
    ref                 INTEGER NOT NULL, -- references label
    name                VARCHAR(255) NOT NULL,
    timesused           INTEGER DEFAULT 0,
    modpending          INTEGER DEFAULT 0,
    lastused            TIMESTAMP
) ENGINE = InnoDB;
-- end

-- create l_album_label
CREATE TABLE IF NOT EXISTS l_album_label
(
   id                  INTEGER NOT NULL,
   link0               INTEGER NOT NULL DEFAULT 0, -- references album
   link1               INTEGER NOT NULL DEFAULT 0, -- references label
   link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_album_label
   begindate           CHAR(10) NOT NULL DEFAULT '',
   enddate             CHAR(10) NOT NULL DEFAULT '',
   modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_artist_label
CREATE TABLE IF NOT EXISTS l_artist_label
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references artist
    link1               INTEGER NOT NULL DEFAULT 0, -- references label
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_artist_label
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_label_label
CREATE TABLE IF NOT EXISTS l_label_label
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references label
    link1               INTEGER NOT NULL DEFAULT 0, -- references label
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_label_label
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_label_track
CREATE TABLE IF NOT EXISTS l_label_track
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references label
    link1               INTEGER NOT NULL DEFAULT 0, -- references track
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_label_track
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create l_label_url
CREATE TABLE IF NOT EXISTS l_label_url
(
    id                  INTEGER NOT NULL,
    link0               INTEGER NOT NULL DEFAULT 0, -- references label
    link1               INTEGER NOT NULL DEFAULT 0, -- references url
    link_type           INTEGER NOT NULL DEFAULT 0, -- references lt_label_url
    begindate           CHAR(10) NOT NULL DEFAULT '',
    enddate             CHAR(10) NOT NULL DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_album_label
CREATE TABLE IF NOT EXISTS lt_album_label
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_artist_label
CREATE TABLE IF NOT EXISTS lt_artist_label
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create lt_label_label
CREATE TABLE IF NOT EXISTS lt_label_label
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end
	
-- create lt_label_track
CREATE TABLE IF NOT EXISTS lt_label_track
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end
 	
-- create lt_label_url
CREATE TABLE IF NOT EXISTS lt_label_url
(
    id                  INTEGER NOT NULL,
    parent              INTEGER NOT NULL, -- references self
    childorder          INTEGER NOT NULL DEFAULT 0,
    mbid                CHAR(36) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    description         TEXT NOT NULL,
    linkphrase          VARCHAR(255) NOT NULL,
    rlinkphrase         VARCHAR(255) NOT NULL,
    attribute           VARCHAR(255) DEFAULT '',
    modpending          INTEGER NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create moderator_subscribe_label
CREATE TABLE IF NOT EXISTS moderator_subscribe_label
(
    id                  INTEGER NOT NULL,
    moderator           INTEGER NOT NULL, -- references moderator
    label               INTEGER NOT NULL, -- weakly references label
    lastmodsent         INTEGER NOT NULL, -- weakly references moderation
    deletedbymod        INTEGER NOT NULL DEFAULT 0, -- weakly references moderation
    mergedbymod         INTEGER NOT NULL DEFAULT 0 -- weakly references moderation
) ENGINE = InnoDB;
-- end

-- create artistwords
CREATE TABLE IF NOT EXISTS artistwords
(
    wordid              INTEGER NOT NULL,
    artistid            INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create labelwords
CREATE TABLE IF NOT EXISTS labelwords
(
    wordid              INTEGER NOT NULL,
    labelid             INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create trackwords
CREATE TABLE IF NOT EXISTS trackwords
(
    wordid              INTEGER NOT NULL,
    trackid             INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create albumwords
CREATE TABLE IF NOT EXISTS albumwords
(
    wordid              INTEGER NOT NULL,
    albumid             INTEGER NOT NULL
) ENGINE = InnoDB;
-- end

-- create wordlist
CREATE TABLE IF NOT EXISTS wordlist
(
    id                  INTEGER NOT NULL,
    word                VARCHAR(255) NOT NULL,
    artistusecount      SMALLINT NOT NULL DEFAULT 0,
    albumusecount       SMALLINT NOT NULL DEFAULT 0,
    trackusecount       SMALLINT NOT NULL DEFAULT 0,
    labelusecount       SMALLINT NOT NULL DEFAULT 0
) ENGINE = InnoDB;
-- end

-- create mycollection
CREATE TABLE IF NOT EXISTS mycollection
(
    idx int PRIMARY KEY,
    uidx int,
    group_id int,
    item_type tinyint,
    gid char(36),
    rating float default 0,
    comment text
) ENGINE = InnoDB;
-- end

-- create mycollection_groups
CREATE TABLE IF NOT EXISTS mycollection_groups
(
    idx int PRIMARY KEY,
    uidx int,
    group_name tinytext,
    comment text
) ENGINE = InnoDB;
-- end

-- create mycollection_users
CREATE TABLE IF NOT EXISTS mycollection_users
(
    idx int PRIMARY KEY,
    username tinytext,
    email tinytext,
    pass tinytext,
    settings text
) ENGINE = InnoDB;
-- end
-- create mycollection_ratings
CREATE TABLE IF NOT EXISTS mycollection_ratings
(
    idx int PRIMARY KEY,
    type char(36),
    artist_id int,
    artist_gid char(36),
    artist_name varchar(255),
    artist_reso varchar(255),
    album_id int,
    album_gid char(36),
    album_name varchar(255),
    rating float,
    ratings int,
    ranking int
) ENGINE = InnoDB;
-- end
-- create livestats
CREATE TABLE IF NOT EXISTS livestats
(
  name VARCHAR(255) PRIMARY KEY,
  val BIGINT DEFAULT 0,
  strval VARCHAR(255)
) ENGINE=InnoDB;
-- end

-- view release_
CREATE VIEW release_ AS SELECT * FROM `release`;
-- end

