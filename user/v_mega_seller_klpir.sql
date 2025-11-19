 SELECT lower(TRIM(BOTH FROM category)) AS category,
    count(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'islamabad'::text) THEN 1
            ELSE NULL::integer
        END) AS islamabad,
    count(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'lahore'::text) THEN 1
            ELSE NULL::integer
        END) AS lahore,
    count(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'rawalpindi'::text) THEN 1
            ELSE NULL::integer
        END) AS rawalpindi,
    count(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'karachi'::text) THEN 1
            ELSE NULL::integer
        END) AS karachi
   FROM stg.mega_sellers
  WHERE ((city = ANY (ARRAY['Islamabad'::text, 'Lahore'::text, 'Rawalpindi'::text, 'Karachi'::text])) AND (category IS NOT NULL))
  GROUP BY (lower(TRIM(BOTH FROM category)))
  ORDER BY (lower(TRIM(BOTH FROM category)));