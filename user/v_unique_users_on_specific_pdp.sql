 SELECT count(DISTINCT vv.userid) AS unique_user,
    p.category_name,
    p.nameen,
    p._id AS product_id,
    sp.sku
   FROM ((stg.visitors vv
     JOIN stg.subproducts sp ON ((vv.productid = sp._id)))
     JOIN stg.products p ON ((sp.productid = p._id)))
  GROUP BY p._id, p.nameen, p.category_name, sp.sku
  ORDER BY (count(DISTINCT vv.userid)) DESC;