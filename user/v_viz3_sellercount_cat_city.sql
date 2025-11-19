 WITH seller_category_city AS (
         SELECT DISTINCT p.category_name,
            b.address_city,
            p.seller_id
           FROM (stg.products p
             JOIN stg.business b ON ((p.seller_id = b.sellerid)))
        ), seller_category_city_counts AS (
         SELECT seller_category_city.category_name,
            count(DISTINCT
                CASE
                    WHEN (lower(seller_category_city.address_city) = 'karachi'::text) THEN seller_category_city.seller_id
                    ELSE NULL::text
                END) AS karachi,
            count(DISTINCT
                CASE
                    WHEN (lower(seller_category_city.address_city) = 'lahore'::text) THEN seller_category_city.seller_id
                    ELSE NULL::text
                END) AS lahore,
            count(DISTINCT
                CASE
                    WHEN ((lower(seller_category_city.address_city) ~~ '%g - 8%'::text) OR (lower(seller_category_city.address_city) ~~ '%g - 9%'::text) OR (lower(seller_category_city.address_city) ~~ '%g - 13%'::text) OR (lower(seller_category_city.address_city) ~~ '%i - 8%'::text) OR (lower(seller_category_city.address_city) ~~ '%islamabad%'::text)) THEN seller_category_city.seller_id
                    ELSE NULL::text
                END) AS islamabad,
            count(DISTINCT
                CASE
                    WHEN (lower(seller_category_city.address_city) = 'peshawar'::text) THEN seller_category_city.seller_id
                    ELSE NULL::text
                END) AS peshawar,
            count(DISTINCT
                CASE
                    WHEN (lower(seller_category_city.address_city) = 'rawalpindi'::text) THEN seller_category_city.seller_id
                    ELSE NULL::text
                END) AS rawalpindi,
            count(DISTINCT
                CASE
                    WHEN ((lower(seller_category_city.address_city) IS NOT NULL) AND (lower(seller_category_city.address_city) <> 'karachi'::text) AND (lower(seller_category_city.address_city) <> 'lahore'::text) AND (lower(seller_category_city.address_city) !~~ '%g - 8%'::text) AND (lower(seller_category_city.address_city) !~~ '%g - 9%'::text) AND (lower(seller_category_city.address_city) !~~ '%g - 13%'::text) AND (lower(seller_category_city.address_city) !~~ '%i - 8%'::text) AND (lower(seller_category_city.address_city) !~~ '%islamabad%'::text) AND (lower(seller_category_city.address_city) <> 'peshawar'::text) AND (lower(seller_category_city.address_city) <> 'rawalpindi'::text)) THEN seller_category_city.seller_id
                    ELSE NULL::text
                END) AS others
           FROM seller_category_city
          GROUP BY seller_category_city.category_name
        )
 SELECT category_name,
    COALESCE(karachi, (0)::bigint) AS karachi,
    COALESCE(lahore, (0)::bigint) AS lahore,
    COALESCE(islamabad, (0)::bigint) AS islamabad,
    COALESCE(peshawar, (0)::bigint) AS peshawar,
    COALESCE(rawalpindi, (0)::bigint) AS rawalpindi,
    COALESCE(others, (0)::bigint) AS others
   FROM seller_category_city_counts
  ORDER BY category_name;