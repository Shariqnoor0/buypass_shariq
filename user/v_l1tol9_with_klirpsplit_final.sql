 WITH sub AS (
         SELECT p._id AS product_id,
            p.seller_city,
            cat.value AS category_name,
            cat.ordinality AS level_no,
            concat('L', cat.ordinality) AS category_level
           FROM (stg.products p
             CROSS JOIN LATERAL jsonb_array_elements_text((p.category_cateogrypath)::jsonb) WITH ORDINALITY cat(value, ordinality))
          WHERE ((cat.ordinality >= 1) AND (cat.ordinality <= 9))
        ), norm AS (
         SELECT sub.product_id,
            sub.category_name,
            sub.level_no,
            sub.category_level,
                CASE
                    WHEN ((sub.seller_city ~* '^\s*islamabad\b'::text) OR (sub.seller_city ~* '^\s*[gfi]\s*[- ]?\s*\d+(?:/\d+)?'::text)) THEN 'Islamabad'::text
                    ELSE sub.seller_city
                END AS city_norm
           FROM sub
        )
 SELECT level_no,
    category_level,
    category_name,
    count(DISTINCT product_id) AS total_products,
    count(DISTINCT product_id) FILTER (WHERE (city_norm = 'Karachi'::text)) AS karachi,
    count(DISTINCT product_id) FILTER (WHERE (city_norm = 'Lahore'::text)) AS lahore,
    count(DISTINCT product_id) FILTER (WHERE (city_norm = 'Peshawar'::text)) AS peshawar,
    count(DISTINCT product_id) FILTER (WHERE (city_norm = 'Islamabad'::text)) AS islamabad,
    count(DISTINCT product_id) FILTER (WHERE (city_norm = 'Rawalpindi'::text)) AS rawalpindi,
    count(DISTINCT product_id) FILTER (WHERE ((city_norm IS NULL) OR (city_norm <> ALL (ARRAY['Karachi'::text, 'Lahore'::text, 'Peshawar'::text, 'Islamabad'::text, 'Rawalpindi'::text])))) AS others
   FROM norm
  GROUP BY level_no, category_level, category_name
  ORDER BY level_no, category_name;