{{ config(materialized='table') }}

WITH base AS (
    SELECT
        session_id,
        song_id,
        user_id,
        artist_id,
        CAST(session_start_time AS timestamp) AS session_start_time,
        price,
        liked,
        liked_since
    FROM deftunes_transform.sessions
),

fact_joined AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['b.session_id', 'b.song_id']) }} AS fact_key,
        b.session_id,
        b.song_id,
        s.song_key,
        u.user_key,
        a.artist_key,
        b.session_start_time,
        DATE(b.session_start_time) AS session_start_time_date_key,
        b.price,
        b.liked,
        b.liked_since
    FROM base b
    LEFT JOIN {{ ref('dim_users') }} u ON b.user_id = u.user_id
    LEFT JOIN {{ ref('dim_songs') }} s ON b.song_id = s.song_id
    LEFT JOIN {{ ref('dim_artists') }} a ON b.artist_id = a.artist_id
    LEFT JOIN {{ ref('dim_dates') }} d on Date(b.session_start_time) = d.date_day
)

SELECT * FROM fact_joined