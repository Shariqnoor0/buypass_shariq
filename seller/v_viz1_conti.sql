 WITH seller_product_counts AS (
         SELECT b.address_city AS city,
            p.seller_id,
            count(p._id) AS product_count
           FROM (stg.products p
             JOIN stg.business b ON ((p.seller_id = b.sellerid)))
          WHERE ((lower(b.address_city) = ANY (ARRAY['karachi'::text, 'lahore'::text, 'peshawar'::text, 'rawalpindi'::text, 'islamabad'::text])) AND (b.isdeleted = 'false'::text))
          GROUP BY b.address_city, p.seller_id
        ), product_buckets AS (
         SELECT
                CASE
                    WHEN (lower(seller_product_counts.city) = ANY (ARRAY['g - 9'::text, 'g - 11'::text, 'g - 8'::text, 'g - 13'::text, 'islamabad'::text])) THEN 'ISLAMABAD'::text
                    WHEN (lower(seller_product_counts.city) ~~ '%karachi%'::text) THEN 'KARACHI'::text
                    WHEN (lower(seller_product_counts.city) ~~ '%lahore%'::text) THEN 'LAHORE'::text
                    WHEN (lower(seller_product_counts.city) ~~ '%rawalpindi%'::text) THEN 'RAWALPINDI'::text
                    WHEN (lower(seller_product_counts.city) ~~ '%peshawar%'::text) THEN 'PESHAWAR'::text
                    ELSE 'Other'::text
                END AS city_group,
                CASE
                    WHEN ((seller_product_counts.product_count >= 1) AND (seller_product_counts.product_count <= 10)) THEN 'A 1-10'::text
                    WHEN ((seller_product_counts.product_count >= 11) AND (seller_product_counts.product_count <= 50)) THEN 'B 11-50'::text
                    WHEN ((seller_product_counts.product_count >= 51) AND (seller_product_counts.product_count <= 100)) THEN 'C 51-100'::text
                    WHEN ((seller_product_counts.product_count >= 101) AND (seller_product_counts.product_count <= 500)) THEN 'D 101-500'::text
                    WHEN ((seller_product_counts.product_count >= 501) AND (seller_product_counts.product_count <= 1000)) THEN 'E 501-1000'::text
                    WHEN (seller_product_counts.product_count > 1000) THEN 'F 1000+'::text
                    ELSE 'Unknown'::text
                END AS product_range,
            count(DISTINCT seller_product_counts.seller_id) AS seller_count
           FROM seller_product_counts
          GROUP BY
                CASE
                    WHEN (lower(seller_product_counts.city) = ANY (ARRAY['g - 9'::text, 'g - 11'::text, 'g - 8'::text, 'g - 13'::text, 'islamabad'::text])) THEN 'ISLAMABAD'::text
                    WHEN (lower(seller_product_counts.city) ~~ '%karachi%'::text) THEN 'KARACHI'::text
                    WHEN (lower(seller_product_counts.city) ~~ '%lahore%'::text) THEN 'LAHORE'::text
                    WHEN (lower(seller_product_counts.city) ~~ '%rawalpindi%'::text) THEN 'RAWALPINDI'::text
                    WHEN (lower(seller_product_counts.city) ~~ '%peshawar%'::text) THEN 'PESHAWAR'::text
                    ELSE 'Other'::text
                END,
                CASE
                    WHEN ((seller_product_counts.product_count >= 1) AND (seller_product_counts.product_count <= 10)) THEN 'A 1-10'::text
                    WHEN ((seller_product_counts.product_count >= 11) AND (seller_product_counts.product_count <= 50)) THEN 'B 11-50'::text
                    WHEN ((seller_product_counts.product_count >= 51) AND (seller_product_counts.product_count <= 100)) THEN 'C 51-100'::text
                    WHEN ((seller_product_counts.product_count >= 101) AND (seller_product_counts.product_count <= 500)) THEN 'D 101-500'::text
                    WHEN ((seller_product_counts.product_count >= 501) AND (seller_product_counts.product_count <= 1000)) THEN 'E 501-1000'::text
                    WHEN (seller_product_counts.product_count > 1000) THEN 'F 1000+'::text
                    ELSE 'Unknown'::text
                END
        )
 SELECT city_group,
    product_range,
    seller_count
   FROM product_buckets
  ORDER BY city_group,
        CASE product_range
            WHEN 'A 1-10'::text THEN 1
            WHEN 'B 11-50'::text THEN 2
            WHEN 'C 51-100'::text THEN 3
            WHEN 'D 101-500'::text THEN 4
            WHEN 'E 501-1000'::text THEN 5
            WHEN 'F 1000+'::text THEN 6
            ELSE 7
        END;