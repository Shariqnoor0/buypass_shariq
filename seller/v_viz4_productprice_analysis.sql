 WITH pricebuckets AS (
         SELECT t.min_price,
            t.max_price,
            t.price_range
           FROM ( VALUES (0,300,'A 0-300'::text), (300,500,'B 300-500'::text), (500,800,'C 500-800'::text), (800,1200,'D 800-1200'::text), (1200,1500,'E 1200-1500'::text), (1500,2000,'F 1500-2000'::text), (2000,3000,'G 2000-3000'::text), (3000,4000,'H 3000-4000'::text), (4000,5000,'I 4000-5000'::text), (5000,NULL::integer,'J 5000+'::text)) t(min_price, max_price, price_range)
        ), productwithpriceint AS (
         SELECT p._id AS product_id,
            p.seller_city,
            category_info.value AS category_name,
            concat('L', category_info.ordinality) AS category_level,
                CASE
                    WHEN (p.lowestprice = 'Infinity'::text) THEN (100000)::numeric
                    ELSE (p.lowestprice)::numeric
                END AS lowestprice_int
           FROM stg.products p,
            LATERAL jsonb_array_elements_text((p.category_cateogrypath)::jsonb) WITH ORDINALITY category_info(value, ordinality)
          WHERE (p.isdeleted = 'false'::text)
        )
 SELECT pwp.product_id,
    pwp.seller_city,
    pwp.category_name,
    pwp.category_level,
    pb.price_range,
    pwp.lowestprice_int
   FROM (productwithpriceint pwp
     JOIN pricebuckets pb ON (((pwp.lowestprice_int >= (pb.min_price)::numeric) AND ((pwp.lowestprice_int < (pb.max_price)::numeric) OR (pb.max_price IS NULL)))))
  ORDER BY pwp.category_name,
        CASE pb.price_range
            WHEN 'A 0-300'::text THEN 1
            WHEN 'B 300-500'::text THEN 2
            WHEN 'C 500-800'::text THEN 3
            WHEN 'D 800-1200'::text THEN 4
            WHEN 'E 1200-1500'::text THEN 5
            WHEN 'F 1500-2000'::text THEN 6
            WHEN 'G 2000-3000'::text THEN 7
            WHEN 'H 3000-4000'::text THEN 8
            WHEN 'I 4000-5000'::text THEN 9
            WHEN 'J 5000+'::text THEN 10
            ELSE 11
        END;