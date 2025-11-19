 WITH cat_split AS (
         SELECT p_1._id AS pdidfromproducts,
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
           FROM (stg.products p_1
             LEFT JOIN LATERAL jsonb_array_elements_text(COALESCE((p_1.category_cateogrypath)::jsonb, '[]'::jsonb)) WITH ORDINALITY j(val, ord) ON (true))
          GROUP BY p_1._id
        )
 SELECT p._id,
    p.category__id,
    p.category_name,
    p.seller_name,
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
     LEFT JOIN cat_split c ON ((c.pdidfromproducts = p._id)));