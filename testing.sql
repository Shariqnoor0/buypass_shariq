 WITH cat_split AS (
         SELECT p._id AS pdidfromproducts,
            max(
                CASE
                    WHEN (j.ord = 1) THEN j.val
                    ELSE NULL::text
                END) AS l1_category,
            max(
                CASE
                    WHEN (j.ord = 2) THEN j.val
                    ELSE NULL::text
                END) AS l2_category,
            max(
                CASE
                    WHEN (j.ord = 3) THEN j.val
                    ELSE NULL::text
                END) AS l3_category,
            max(
                CASE
                    WHEN (j.ord = 4) THEN j.val
                    ELSE NULL::text
                END) AS l4_category,
            max(
                CASE
                    WHEN (j.ord = 5) THEN j.val
                    ELSE NULL::text
                END) AS l5_category,
            max(
                CASE
                    WHEN (j.ord = 6) THEN j.val
                    ELSE NULL::text
                END) AS l6_category,
            max(
                CASE
                    WHEN (j.ord = 7) THEN j.val
                    ELSE NULL::text
                END) AS l7_category,
            max(
                CASE
                    WHEN (j.ord = 8) THEN j.val
                    ELSE NULL::text
                END) AS l8_category,
            max(
                CASE
                    WHEN (j.ord = 9) THEN j.val
                    ELSE NULL::text
                END) AS l9_category
           FROM (stg.products p
             LEFT JOIN LATERAL jsonb_array_elements_text(COALESCE((p.category_cateogrypath)::jsonb, '[]'::jsonb)) WITH ORDINALITY j(val, ord) ON (true))
          WHERE (p.isdeleted = 'false'::text)
          GROUP BY p._id
        ), product_data AS (
         SELECT p._id,
            p.category__id,
            p.category_name,
            p.seller_name,
            p.seller_city,
            p.category_cateogrypath,
            p.nameen AS product_name,
            s.sku,
            p._id AS pdidfromproducts,
            p.seller_id,
            s.price AS skuprice,
            p.lowestprice AS productprice,
            s._id AS skuid,
            s.productid AS productidfromsub,
            s.stock,
            s.sold,
            c.l1_category,
            c.l2_category,
            c.l3_category,
            c.l4_category,
            c.l5_category,
            c.l6_category,
            c.l7_category,
            c.l8_category,
            c.l9_category
           FROM ((stg.subproducts s
             RIGHT JOIN stg.products p ON ((s.productid = p._id)))
             LEFT JOIN cat_split c ON ((c.pdidfromproducts = p._id)))
          WHERE (p.isdeleted = 'false'::text)
        ), product_categories AS (
         SELECT p._id AS product_id,
            category_info.value AS exploded_category_name,
            concat('L', category_info.ordinality) AS category_level
           FROM (stg.products p
             CROSS JOIN LATERAL jsonb_array_elements_text(COALESCE((p.category_cateogrypath)::jsonb, '[]'::jsonb)) WITH ORDINALITY category_info(value, ordinality))
          WHERE (p.isdeleted = 'false'::text)
        ), city_counts AS (
         SELECT category_info.value AS category_name,
            concat('L', category_info.ordinality) AS category_level,
            count(DISTINCT p._id) FILTER (WHERE ((p.seller_city ~~* '%g - 8%'::text) OR (p.seller_city ~~* '%g - 9%'::text) OR (p.seller_city ~~* '%g - 13%'::text) OR (p.seller_city ~~* '%i - 8%'::text) OR (p.seller_city ~~* '%islamabad%'::text))) AS islamabad,
            count(DISTINCT p._id) FILTER (WHERE (p.seller_city = 'Karachi'::text)) AS karachi,
            count(DISTINCT p._id) FILTER (WHERE (p.seller_city = 'Lahore'::text)) AS lahore,
            count(DISTINCT p._id) FILTER (WHERE (p.seller_city = 'Peshawar'::text)) AS peshawar,
            count(DISTINCT p._id) FILTER (WHERE (p.seller_city = 'Rawalpindi'::text)) AS rawalpindi,
            count(DISTINCT p._id) FILTER (WHERE ((NOT ((p.seller_city ~~* '%g - 8%'::text) OR (p.seller_city ~~* '%g - 9%'::text) OR (p.seller_city ~~* '%g - 13%'::text) OR (p.seller_city ~~* '%i - 8%'::text) OR (p.seller_city ~~* '%islamabad%'::text) OR (p.seller_city = ANY (ARRAY['Karachi'::text, 'Lahore'::text, 'Peshawar'::text, 'Rawalpindi'::text])))) OR (p.seller_city IS NULL))) AS other
           FROM (stg.products p
             CROSS JOIN LATERAL jsonb_array_elements_text(COALESCE((p.category_cateogrypath)::jsonb, '[]'::jsonb)) WITH ORDINALITY category_info(value, ordinality))
          WHERE (p.isdeleted = 'false'::text)
          GROUP BY category_info.value, (concat('L', category_info.ordinality))
        )
 SELECT pd._id,
    pd.category__id,
    pd.category_name AS product_category_name,
    pd.seller_name,
    pd.seller_city,
    pd.category_cateogrypath,
    pd.product_name,
    pd.sku,
    pd.pdidfromproducts,
    pd.seller_id,
    pd.skuprice,
    pd.productprice,
    pd.skuid,
    pd.productidfromsub,
    pd.stock,
    pd.sold,
    pd.l1_category,
    pd.l2_category,
    pd.l3_category,
    pd.l4_category,
    pd.l5_category,
    pd.l6_category,
    pd.l7_category,
    pd.l8_category,
    pd.l9_category,
    pc.exploded_category_name AS category_name,
    pc.category_level,
    cc.islamabad,
    cc.karachi,
    cc.lahore,
    cc.peshawar,
    cc.rawalpindi,
    cc.other
   FROM ((product_data pd
     LEFT JOIN product_categories pc ON ((pc.product_id = pd._id)))
     LEFT JOIN city_counts cc ON (((cc.category_name = pc.exploded_category_name) AND (cc.category_level = pc.category_level))))
  ORDER BY pd.category_name, pd._id, pc.category_level;