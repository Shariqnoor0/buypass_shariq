 SELECT category_name,
    product_id,
    category_level,
    count(DISTINCT product_id) FILTER (WHERE ((seller_city ~~* '%g - 8%'::text) OR (seller_city ~~* '%g - 9%'::text) OR (seller_city ~~* '%g - 13%'::text) OR (seller_city ~~* '%i - 8%'::text) OR (seller_city ~~* '%islamabad%'::text))) AS islamabad,
    count(DISTINCT product_id) FILTER (WHERE (seller_city = 'Karachi'::text)) AS karachi,
    count(DISTINCT product_id) FILTER (WHERE (seller_city = 'Lahore'::text)) AS lahore,
    count(DISTINCT product_id) FILTER (WHERE (seller_city = 'Peshawar'::text)) AS peshawar,
    count(DISTINCT product_id) FILTER (WHERE (seller_city = 'Rawalpindi'::text)) AS rawalpindi,
    count(DISTINCT product_id) FILTER (WHERE ((NOT ((seller_city ~~* '%g - 8%'::text) OR (seller_city ~~* '%g - 9%'::text) OR (seller_city ~~* '%g - 13%'::text) OR (seller_city ~~* '%i - 8%'::text) OR (seller_city ~~* '%islamabad%'::text) OR (seller_city = ANY (ARRAY['Karachi'::text, 'Lahore'::text, 'Peshawar'::text, 'Rawalpindi'::text])))) OR (seller_city IS NULL))) AS other
   FROM ( SELECT products._id AS product_id,
            products.nameen AS product_name,
            products.seller_id,
            products.seller_name,
            products.seller_city,
            category_info.value AS category_name,
            concat('L', category_info.ordinality) AS category_level
           FROM stg.products,
            LATERAL jsonb_array_elements_text((products.category_cateogrypath)::jsonb) WITH ORDINALITY category_info(value, ordinality)) sub
  GROUP BY category_name, category_level, product_id
  ORDER BY category_name;