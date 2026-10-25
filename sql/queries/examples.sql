-- Example queries. See the README for how to run them.

-- 1. Summary statistics per series
SELECT
    s.name,
    COUNT(*)                    AS n,
    MIN(o.value)                AS min_value,
    MAX(o.value)                AS max_value,
    ROUND(AVG(o.value), 4)      AS mean,
    ROUND(STDDEV_SAMP(o.value), 4) AS std_dev
FROM observations o
JOIN series s ON s.id = o.series_id
GROUP BY s.id, s.name;

-- 2. 3-day moving average (MySQL 8 window function)
SELECT
    s.name,
    o.observed_at,
    o.value,
    ROUND(AVG(o.value) OVER (
        PARTITION BY o.series_id
        ORDER BY o.observed_at
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 4) AS moving_avg_3
FROM observations o
JOIN series s ON s.id = o.series_id
ORDER BY s.name, o.observed_at;

-- 3. Day-over-day change
SELECT
    s.name,
    o.observed_at,
    o.value,
    o.value - LAG(o.value) OVER (
        PARTITION BY o.series_id ORDER BY o.observed_at
    ) AS change_from_previous
FROM observations o
JOIN series s ON s.id = o.series_id
ORDER BY s.name, o.observed_at;

-- 4. Median per series (percentile via row numbering)
SELECT name, ROUND(AVG(value), 4) AS median
FROM (
    SELECT
        s.name,
        o.value,
        ROW_NUMBER() OVER (PARTITION BY o.series_id ORDER BY o.value) AS rn,
        COUNT(*)     OVER (PARTITION BY o.series_id)                  AS cnt
    FROM observations o
    JOIN series s ON s.id = o.series_id
) ranked
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2))
GROUP BY name;
