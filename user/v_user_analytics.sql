-- View: test.v_user_analytics

-- DROP VIEW test.v_user_analytics;

CREATE OR REPLACE VIEW stg.v_user_analytics
 AS
 WITH dailyanalytics AS (
         SELECT user_analytics."timestamp"::date AS day,
            count(DISTINCT user_analytics.userid) AS dau,
            count(DISTINCT
                CASE
                    WHEN user_analytics.type = 'PRODUCT_DETAIL_VIEW'::text THEN user_analytics.userid
                    ELSE NULL::text
                END) AS pdp_uvs
           FROM stg.user_analytics
          GROUP BY (user_analytics."timestamp"::date)
        ), orderbase AS (
         SELECT "order".createdon::date AS order_day,
            "order".address_userid AS buyer_id,
            "order".buypassid AS order_id,
            "order".product_id
           FROM stg."order"
          WHERE "order".buypassid IS NOT NULL
        ), productprimarycategories AS (
         SELECT products._id AS product_id,
            TRIM(BOTH '"'::text FROM split_part(replace(replace(products.category_cateogrypath, '['::text, ''::text), ']'::text, ''::text), ','::text, 1)) AS primary_category
           FROM stg.products
          WHERE products.category_cateogrypath IS NOT NULL AND products.category_cateogrypath <> '[]'::text
        ), ordercategories AS (
         SELECT ob.order_day,
            ob.buyer_id,
            ob.order_id,
            ob.product_id,
            COALESCE(pc.primary_category, 'No Category'::text) AS primary_category
           FROM orderbase ob
             LEFT JOIN productprimarycategories pc ON ob.product_id = pc.product_id
        ), buyerprimarycategories AS (
         SELECT ordercategories.order_day,
            ordercategories.buyer_id,
            ordercategories.primary_category,
            count(*) AS category_count,
            row_number() OVER (PARTITION BY ordercategories.order_day, ordercategories.buyer_id ORDER BY (count(*)) DESC, ordercategories.primary_category) AS rn
           FROM ordercategories
          GROUP BY ordercategories.order_day, ordercategories.buyer_id, ordercategories.primary_category
        ), buyercategoryassignment AS (
         SELECT buyerprimarycategories.order_day,
            buyerprimarycategories.buyer_id,
            buyerprimarycategories.primary_category
           FROM buyerprimarycategories
          WHERE buyerprimarycategories.rn = 1
        ), categorymetrics AS (
         SELECT oc.order_day,
            bca.primary_category AS category,
            count(DISTINCT bca.buyer_id) AS category_buyers,
            count(DISTINCT oc.order_id) AS category_orders
           FROM ordercategories oc
             JOIN buyercategoryassignment bca ON oc.order_day = bca.order_day AND oc.buyer_id = bca.buyer_id
          GROUP BY oc.order_day, bca.primary_category
        ), dailytotals AS (
         SELECT orderbase.order_day,
            count(DISTINCT orderbase.buyer_id) AS total_buyers,
            count(DISTINCT orderbase.order_id) AS total_orders
           FROM orderbase
          GROUP BY orderbase.order_day
        )
 SELECT EXTRACT(month FROM da.day) AS month_numeric,
    da.day AS day_date,
    da.dau,
    COALESCE(da.pdp_uvs, 0::bigint) AS pdp_uvs,
    COALESCE(dt.total_buyers, 0::bigint) AS total_buyers,
    COALESCE(dt.total_orders, 0::bigint) AS total_orders,
    cm.category,
    COALESCE(cm.category_buyers, 0::bigint) AS category_buyers,
    COALESCE(cm.category_orders, 0::bigint) AS category_orders
   FROM dailyanalytics da
     LEFT JOIN dailytotals dt ON da.day = dt.order_day
     LEFT JOIN categorymetrics cm ON da.day = cm.order_day
  ORDER BY cm.category_buyers DESC, cm.category_orders DESC;



