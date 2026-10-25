-- Runs automatically on first start (see docker-compose.yml).
-- Database and user are created by the MYSQL_* environment variables.

CREATE TABLE IF NOT EXISTS series (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    unit        VARCHAR(30)  NULL,
    description TEXT         NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_series_name (name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS observations (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    series_id   INT UNSIGNED    NOT NULL,
    observed_at DATETIME        NOT NULL,
    value       DECIMAL(18, 6)  NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_series_time (series_id, observed_at),
    KEY idx_observed_at (observed_at),
    CONSTRAINT fk_obs_series
        FOREIGN KEY (series_id) REFERENCES series (id)
        ON DELETE CASCADE
) ENGINE=InnoDB;
