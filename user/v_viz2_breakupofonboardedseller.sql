 WITH seller_products AS (
         SELECT p.seller_id,
            b.address_city AS city,
                CASE
                    WHEN (p.lowestprice ~ '^[0-9.]+$'::text) THEN (p.lowestprice)::numeric
                    ELSE NULL::numeric
                END AS price
           FROM (stg.products p
             JOIN stg.business b ON ((p.seller_id = b.sellerid)))
          WHERE (p.lowestprice ~ '^[0-9.]+$'::text)
        ), price_grouped AS (
         SELECT seller_products.seller_id,
            lower(seller_products.city) AS city,
                CASE
                    WHEN ((seller_products.price >= (0)::numeric) AND (seller_products.price <= (500)::numeric)) THEN '0-500'::text
                    WHEN ((seller_products.price >= (501)::numeric) AND (seller_products.price <= (1000)::numeric)) THEN '501-1000'::text
                    WHEN ((seller_products.price >= (1001)::numeric) AND (seller_products.price <= (1500)::numeric)) THEN '1001-1500'::text
                    WHEN (seller_products.price > (1500)::numeric) THEN '1500+'::text
                    ELSE 'Unknown'::text
                END AS price_range
           FROM seller_products
        ), distinct_seller_city_price AS (
         SELECT DISTINCT price_grouped.seller_id,
            price_grouped.city,
            price_grouped.price_range
           FROM price_grouped
        ), final_counts AS (
         SELECT
                CASE
                    WHEN (distinct_seller_city_price.city = ANY (ARRAY['g - 11'::text, 'i - 8'::text, 'g - 8'::text, 'g - 13'::text, 'g - 9'::text, 'islamabad'::text])) THEN 'ISLAMABAD'::text
                    WHEN (distinct_seller_city_price.city ~~ '%karachi%'::text) THEN 'KARACHI'::text
                    WHEN (distinct_seller_city_price.city ~~ '%lahore%'::text) THEN 'LAHORE'::text
                    WHEN (distinct_seller_city_price.city ~~ '%rawalpindi%'::text) THEN 'RAWALPINDI'::text
                    WHEN (distinct_seller_city_price.city ~~ '%peshawar%'::text) THEN 'PESHAWAR'::text
                    ELSE 'Other'::text
                END AS city_group,
            distinct_seller_city_price.price_range,
            count(DISTINCT distinct_seller_city_price.seller_id) AS seller_count
           FROM distinct_seller_city_price
          GROUP BY
                CASE
                    WHEN (distinct_seller_city_price.city = ANY (ARRAY['g - 11'::text, 'i - 8'::text, 'g - 8'::text, 'g - 13'::text, 'g - 9'::text, 'islamabad'::text])) THEN 'ISLAMABAD'::text
                    WHEN (distinct_seller_city_price.city ~~ '%karachi%'::text) THEN 'KARACHI'::text
                    WHEN (distinct_seller_city_price.city ~~ '%lahore%'::text) THEN 'LAHORE'::text
                    WHEN (distinct_seller_city_price.city ~~ '%rawalpindi%'::text) THEN 'RAWALPINDI'::text
                    WHEN (distinct_seller_city_price.city ~~ '%peshawar%'::text) THEN 'PESHAWAR'::text
                    ELSE 'Other'::text
                END, distinct_seller_city_price.price_range
        )
 SELECT city_group,
    price_range,
    seller_count
   FROM final_counts
  ORDER BY city_group,
        CASE price_range
            WHEN '0-500'::text THEN 1
            WHEN '501-1000'::text THEN 2
            WHEN '1001-1500'::text THEN 3
            WHEN '1500+'::text THEN 4
            WHEN 'Unknown'::text THEN 5
            ELSE 6
        END;