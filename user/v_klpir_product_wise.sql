 WITH cte AS (
         SELECT DISTINCT p.seller_id,
            b.sellerid,
            p.nameen,
            p.seller_name,
            p.seller_city,
            p.status AS product_status,
            b.fullname,
            b.status AS seller_status,
            b.address_city,
            b.isdeleted,
            b.storename,
                CASE
                    WHEN (lower(b.address_city) = 'karachi'::text) THEN 'Karachi'::text
                    WHEN (lower(b.address_city) = 'lahore'::text) THEN 'Lahore'::text
                    WHEN (lower(b.address_city) = 'peshawar'::text) THEN 'Peshawar'::text
                    WHEN (lower(b.address_city) = 'rawalpindi'::text) THEN 'Rawalpindi'::text
                    WHEN (lower(b.address_city) = 'islamabad'::text) THEN 'Islamabad'::text
                    WHEN ((b.address_city IS NULL) OR (b.address_city = ''::text)) THEN 'No City Mentioned'::text
                    ELSE 'Others'::text
                END AS city_category
           FROM (stg.products p
             JOIN stg.business b ON ((p.seller_id = b.sellerid)))
          WHERE (b.isdeleted = 'false'::text)
        )
 SELECT seller_id,
    sellerid,
    nameen,
    seller_name,
    seller_city,
    product_status,
    fullname,
    seller_status,
    address_city,
    city_category,
    storename
   FROM cte
  WHERE (isdeleted = 'false'::text);