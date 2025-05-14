
-- Use the `ref` function to select from other models
{{ config(materialized='table') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['song_id']) }} AS song_key,
    song_id,
    title AS song_title,
    track_id,
    release,
    duration,
    year
FROM deftunes_transform.songs
WHERE song_id IS NOT NULL
