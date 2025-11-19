 SELECT category_name,
    createdon,
        CASE
            WHEN (lowestprice ~ '^\d+$'::text) THEN (lowestprice)::integer
            ELSE NULL::integer
        END AS lowestprice_int,
    nameen,
    seller_name,
    seller_city,
    seller_status
   FROM stg.products;