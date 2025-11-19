 SELECT seller_type,
    sum(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'islamabad'::text) THEN 1
            ELSE 0
        END) AS islamabad,
    sum(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'karachi'::text) THEN 1
            ELSE 0
        END) AS karachi,
    sum(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'lahore'::text) THEN 1
            ELSE 0
        END) AS lahore,
    sum(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'peshawar'::text) THEN 1
            ELSE 0
        END) AS peshawar,
    sum(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'rawalpindi'::text) THEN 1
            ELSE 0
        END) AS rawalpindi,
    sum(
        CASE
            WHEN (lower(TRIM(BOTH FROM city)) = 'rawalpindi/islamabad'::text) THEN 1
            ELSE 0
        END) AS rawalpindi_islamabad
   FROM ( SELECT lower(TRIM(BOTH FROM response.city)) AS city,
            lower(TRIM(BOTH FROM response.seller_type)) AS seller_type
           FROM stg.response
          WHERE ((response.city IS NOT NULL) AND (response.seller_type IS NOT NULL) AND (response.seller_definition IS NOT NULL) AND (lower(response.seller_definition) = 'new customer'::text))) sub
  GROUP BY seller_type
  ORDER BY seller_type;