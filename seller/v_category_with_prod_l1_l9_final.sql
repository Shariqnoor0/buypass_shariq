 SELECT products._id AS product_id,
    products.nameen AS product_name,
    products.seller_id,
    products.seller_name,
    products.seller_city,
    category_info.value AS category_name,
    concat('L', category_info.ordinality) AS category_level
   FROM stg.products,
    LATERAL jsonb_array_elements_text((products.category_cateogrypath)::jsonb) WITH ORDINALITY category_info(value, ordinality);