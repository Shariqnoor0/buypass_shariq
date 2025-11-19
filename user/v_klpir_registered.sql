 SELECT status,
    sum(
        CASE
            WHEN (lower(address_city) = 'karachi'::text) THEN 1
            ELSE 0
        END) AS karachi,
    sum(
        CASE
            WHEN (lower(address_city) = 'lahore'::text) THEN 1
            ELSE 0
        END) AS lahore,
    sum(
        CASE
            WHEN (lower(address_city) = 'peshawar'::text) THEN 1
            ELSE 0
        END) AS peshawar,
    sum(
        CASE
            WHEN (lower(address_city) = 'rawalpindi'::text) THEN 1
            ELSE 0
        END) AS rawalpindi,
    sum(
        CASE
            WHEN (lower(address_city) = 'islamabad'::text) THEN 1
            ELSE 0
        END) AS islamabad,
    sum(
        CASE
            WHEN ((lower(address_city) <> ALL (ARRAY['karachi'::text, 'lahore'::text, 'peshawar'::text, 'rawalpindi'::text, 'islamabad'::text])) AND (lower(address_city) IS NOT NULL)) THEN 1
            ELSE 0
        END) AS others,
    sum(
        CASE
            WHEN (lower(address_city) IS NULL) THEN 1
            ELSE 0
        END) AS no_city_mentioned,
    address_city,
    sellerid
   FROM stg.business
  WHERE (isdeleted = 'false'::text)
  GROUP BY address_city, sellerid, status;