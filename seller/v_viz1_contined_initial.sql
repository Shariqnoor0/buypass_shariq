 WITH signed_up AS (
         SELECT
                CASE
                    WHEN (lower(b.address_city) = ANY (ARRAY['karachi'::text, 'lahore'::text, 'peshawar'::text, 'rawalpindi'::text, 'islamabad'::text])) THEN lower(b.address_city)
                    ELSE 'other cities'::text
                END AS city,
            count(b.sellerid) AS signed_up
           FROM stg.business b
          WHERE (b.isdeleted = 'false'::text)
          GROUP BY
                CASE
                    WHEN (lower(b.address_city) = ANY (ARRAY['karachi'::text, 'lahore'::text, 'peshawar'::text, 'rawalpindi'::text, 'islamabad'::text])) THEN lower(b.address_city)
                    ELSE 'other cities'::text
                END
        ), onboarded AS (
         SELECT
                CASE
                    WHEN (lower(b.address_city) = ANY (ARRAY['karachi'::text, 'lahore'::text, 'peshawar'::text, 'rawalpindi'::text, 'islamabad'::text])) THEN lower(b.address_city)
                    ELSE 'other cities'::text
                END AS city,
            count(DISTINCT p_1.seller_id) AS onboarded
           FROM (stg.products p_1
             JOIN stg.business b ON ((p_1.seller_id = b.sellerid)))
          WHERE (b.isdeleted = 'false'::text)
          GROUP BY
                CASE
                    WHEN (lower(b.address_city) = ANY (ARRAY['karachi'::text, 'lahore'::text, 'peshawar'::text, 'rawalpindi'::text, 'islamabad'::text])) THEN lower(b.address_city)
                    ELSE 'other cities'::text
                END
        ), seller_product_counts AS (
         SELECT
                CASE
                    WHEN (lower(b.address_city) = ANY (ARRAY['karachi'::text, 'lahore'::text, 'peshawar'::text, 'rawalpindi'::text, 'islamabad'::text])) THEN lower(b.address_city)
                    ELSE 'other cities'::text
                END AS city,
            p_1.seller_id,
            count(p_1._id) AS product_count
           FROM (stg.products p_1
             JOIN stg.business b ON ((p_1.seller_id = b.sellerid)))
          WHERE (b.isdeleted = 'false'::text)
          GROUP BY
                CASE
                    WHEN (lower(b.address_city) = ANY (ARRAY['karachi'::text, 'lahore'::text, 'peshawar'::text, 'rawalpindi'::text, 'islamabad'::text])) THEN lower(b.address_city)
                    ELSE 'other cities'::text
                END, p_1.seller_id
        ), percentage_of_ro AS (
         SELECT COALESCE(s_1.city, o_1.city) AS city,
            COALESCE(s_1.signed_up, (0)::bigint) AS signed_up,
            COALESCE(o_1.onboarded, (0)::bigint) AS onboarded,
                CASE
                    WHEN (COALESCE(s_1.signed_up, (0)::bigint) = 0) THEN (0)::numeric
                    ELSE round((((COALESCE(o_1.onboarded, (0)::bigint))::numeric / (s_1.signed_up)::numeric) * (100)::numeric), 2)
                END AS onboard_percentage
           FROM (signed_up s_1
             FULL JOIN onboarded o_1 ON ((s_1.city = o_1.city)))
        ), product_buckets AS (
         SELECT seller_product_counts.city,
            count(DISTINCT seller_product_counts.seller_id) AS total_sellers,
            sum(
                CASE
                    WHEN ((seller_product_counts.product_count >= 1) AND (seller_product_counts.product_count <= 10)) THEN 1
                    ELSE 0
                END) AS "1_to_10",
            sum(
                CASE
                    WHEN ((seller_product_counts.product_count >= 11) AND (seller_product_counts.product_count <= 50)) THEN 1
                    ELSE 0
                END) AS "10_to_50",
            sum(
                CASE
                    WHEN ((seller_product_counts.product_count >= 51) AND (seller_product_counts.product_count <= 100)) THEN 1
                    ELSE 0
                END) AS "50_to_100",
            sum(
                CASE
                    WHEN ((seller_product_counts.product_count >= 101) AND (seller_product_counts.product_count <= 500)) THEN 1
                    ELSE 0
                END) AS "100_to_500",
            sum(
                CASE
                    WHEN ((seller_product_counts.product_count >= 501) AND (seller_product_counts.product_count <= 1000)) THEN 1
                    ELSE 0
                END) AS "500_to_1000",
            sum(
                CASE
                    WHEN (seller_product_counts.product_count > 1000) THEN 1
                    ELSE 0
                END) AS "1000_plus"
           FROM seller_product_counts
          GROUP BY seller_product_counts.city
        )
 SELECT COALESCE(s.city, o.city, p.city, r.city) AS city,
    COALESCE(s.signed_up, (0)::bigint) AS signed_up,
    COALESCE(o.onboarded, (0)::bigint) AS onboarded,
    COALESCE(r.onboard_percentage, (0)::numeric) AS onboard_percentage,
    COALESCE(p."1_to_10", (0)::bigint) AS "1_to_10",
    COALESCE(p."10_to_50", (0)::bigint) AS "10_to_50",
    COALESCE(p."50_to_100", (0)::bigint) AS "50_to_100",
    COALESCE(p."100_to_500", (0)::bigint) AS "100_to_500",
    COALESCE(p."500_to_1000", (0)::bigint) AS "500_to_1000",
    COALESCE(p."1000_plus", (0)::bigint) AS "1000_plus"
   FROM (((signed_up s
     FULL JOIN onboarded o ON ((s.city = o.city)))
     FULL JOIN product_buckets p ON ((COALESCE(s.city, o.city) = p.city)))
     FULL JOIN percentage_of_ro r ON ((COALESCE(s.city, o.city, p.city) = r.city)))
  ORDER BY
        CASE COALESCE(s.city, o.city, p.city, r.city)
            WHEN 'karachi'::text THEN 1
            WHEN 'lahore'::text THEN 2
            WHEN 'rawalpindi'::text THEN 3
            WHEN 'islamabad'::text THEN 4
            WHEN 'peshawar'::text THEN 5
            WHEN 'other cities'::text THEN 6
            ELSE 7
        END;