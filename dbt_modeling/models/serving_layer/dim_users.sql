
-- Use the `ref` function to select from other models
{{ config(materialized='table') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_key,
    user_id,
    user_lastname,
    user_name,
    CAST(user_since AS timestamp) AS user_since,
    country_code
FROM deftunes_transform.users
WHERE user_id IS NOT NULL
