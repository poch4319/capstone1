{{ config(materialized='table') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['artist_id']) }} AS artist_key,
    artist_id,
    artist_name,
    artist_familiarity,
    artist_hotttnesss AS artist_hotness
FROM deftunes_transform.songs
WHERE artist_id IS NOT NULL