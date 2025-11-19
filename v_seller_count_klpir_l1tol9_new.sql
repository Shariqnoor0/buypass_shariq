 WITH sub AS (
         SELECT p._id AS product_id,
            p.nameen AS product_name,
            p.seller_id,
            p.seller_name,
            p.seller_city,
            ci.value AS category_name,
            concat('L', ci.ordinality) AS category_level
           FROM (stg.products p
             CROSS JOIN LATERAL jsonb_array_elements_text((p.category_cateogrypath)::jsonb) WITH ORDINALITY ci(value, ordinality))
        ), sub_norm AS (
         SELECT s.product_id,
            s.product_name,
            s.seller_id,
            s.seller_name,
            s.seller_city,
            s.category_name,
            s.category_level,
                CASE
                    WHEN ((s.seller_city ~* '^\s*islamabad\b'::text) OR (s.seller_city ~* '^\s*[gfi]\s*[- ]?\s*\d+'::text)) THEN 'Islamabad'::text
                    ELSE s.seller_city
                END AS city_norm
           FROM sub s
        )
 SELECT seller_id,
    seller_name,
    category_name,
    category_level,
    count(DISTINCT seller_id) FILTER (WHERE (city_norm = 'Islamabad'::text)) AS islamabad,
    count(DISTINCT seller_id) FILTER (WHERE (city_norm = 'Karachi'::text)) AS karachi,
    count(DISTINCT seller_id) FILTER (WHERE (city_norm = 'Lahore'::text)) AS lahore,
    count(DISTINCT seller_id) FILTER (WHERE (city_norm = 'Peshawar'::text)) AS peshawar,
    count(DISTINCT seller_id) FILTER (WHERE (city_norm = 'Rawalpindi'::text)) AS rawalpindi,
    count(DISTINCT seller_id) FILTER (WHERE ((city_norm IS NULL) OR (city_norm <> ALL (ARRAY['Islamabad'::text, 'Karachi'::text, 'Lahore'::text, 'Peshawar'::text, 'Rawalpindi'::text])))) AS other
   FROM sub_norm
  GROUP BY category_name, category_level, seller_id, seller_name
  ORDER BY category_name;