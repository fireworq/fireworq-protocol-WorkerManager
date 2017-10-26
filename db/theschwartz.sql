CREATE TABLE IF NOT EXISTS funcmap (
        funcid         INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
        funcname       VARCHAR(255) NOT NULL,
        UNIQUE(funcname)
) DEFAULT CHARSET=binary;

CREATE TABLE IF NOT EXISTS job (
        jobid           BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
        funcid          INT UNSIGNED NOT NULL,
        arg             MEDIUMBLOB,
        uniqkey         VARCHAR(255) NULL,
        insert_time     INTEGER UNSIGNED,
        run_after       INTEGER UNSIGNED NOT NULL,
        grabbed_until   INTEGER UNSIGNED NOT NULL,
        priority        SMALLINT UNSIGNED,
        coalesce        VARCHAR(255),
        INDEX (funcid, run_after),
        UNIQUE(funcid, uniqkey),
        INDEX (funcid, coalesce)
) DEFAULT CHARSET=binary;

CREATE TABLE IF NOT EXISTS note (
        jobid           BIGINT UNSIGNED NOT NULL,
        notekey         VARCHAR(255),
        PRIMARY KEY (jobid, notekey),
        value           MEDIUMBLOB
) DEFAULT CHARSET=binary;

CREATE TABLE IF NOT EXISTS error (
        error_time      INTEGER UNSIGNED NOT NULL,
        jobid           BIGINT UNSIGNED NOT NULL,
        message         VARCHAR(255) NOT NULL,
        funcid          INT UNSIGNED NOT NULL DEFAULT 0,
        INDEX (funcid, error_time),
        INDEX (error_time),
        INDEX (jobid)
) DEFAULT CHARSET=binary;

CREATE TABLE IF NOT EXISTS exitstatus (
        jobid           BIGINT UNSIGNED PRIMARY KEY NOT NULL,
        funcid          INT UNSIGNED NOT NULL DEFAULT 0,
        status          SMALLINT UNSIGNED,
        completion_time INTEGER UNSIGNED,
        delete_after    INTEGER UNSIGNED,
        INDEX (funcid),
        INDEX (delete_after)
) DEFAULT CHARSET=binary;
