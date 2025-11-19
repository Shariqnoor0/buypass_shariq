 WITH cte AS (
         SELECT count(DISTINCT p.category_name) AS count,
            p.seller_id AS sellerid_product,
            b.sellerid AS sellerid_business,
            b.address_city AS city,
            b.address_state AS province,
            b.fullname AS seller_name,
            b.sellertype,
            b.isdeleted,
            b.storename
           FROM (stg.products p
             RIGHT JOIN stg.business b ON ((p.seller_id = b.sellerid)))
          GROUP BY p.seller_id, b.address_city, b.address_state, b.fullname, b.sellertype, b.isdeleted, b.storename, b.sellerid
        )
 SELECT sellerid_product,
    sellerid_business,
    city,
    province,
    seller_name,
    sellertype,
    storename,
        CASE
            WHEN (count = 1) THEN 'single_cat_seller'::text
            WHEN (count > 1) THEN 'multi_cat_seller'::text
            ELSE 'no_cat'::text
        END AS seller_category
   FROM cte
  WHERE (isdeleted = 'false'::text);