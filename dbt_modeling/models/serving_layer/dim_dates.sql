-- {{ config(materialized='table') }}

-- SELECT DISTINCT
--     CAST(session_start_time AS DATE) AS date_key,
--     EXTRACT(month FROM session_start_time) AS month,
--     EXTRACT(year FROM session_start_time) AS year,
--     TO_CHAR(session_start_time, 'Day') AS day_of_week
-- FROM deftunes_transform.sessions



with date_dimension as (
    select * from {{ ref('dates') }}
)

SELECT
    date_day,
    day_of_week,
    day_of_month,
    day_of_year,
    week_of_year,
    month_of_year,
    month_name,
    quarter_of_year,
    year_number
FROM
    date_dimension d