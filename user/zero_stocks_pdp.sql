 WITH cte AS (
         SELECT ((user_analytics.data)::json ->> 'productId'::text) AS sub_product_id,
            ((user_analytics.data)::json ->> 'sellerId'::text) AS seller_id,
            ((user_analytics.data)::json ->> 'storeId'::text) AS store_id,
            user_analytics.userid,
            user_analytics.type,
            user_analytics.platform,
            user_analytics.screen,
            user_analytics.os,
            user_analytics.browser,
            user_analytics.data,
            user_analytics.deviceid,
            user_analytics.adid,
            user_analytics.referer,
            user_analytics.ip,
            user_analytics.useragent,
            user_analytics.usertype,
            user_analytics."timestamp"
           FROM stg.user_analytics
          WHERE (user_analytics.type = 'PRODUCT_DETAIL_VIEW'::text)
        )
 SELECT p.isavailable,
    p.price,
    p.sku,
    p.stock,
    ps.category_name,
    ps.nameen,
    b.address_shopname,
    b.sellerid
   FROM (((cte c
     JOIN stg.subproducts p ON ((p._id = c.sub_product_id)))
     JOIN stg.products ps ON ((ps._id = p.productid)))
     JOIN stg.business b ON ((b.sellerid = ps.seller_id)));