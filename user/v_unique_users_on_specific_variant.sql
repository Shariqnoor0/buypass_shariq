 SELECT count(DISTINCT vv.userid) AS unique_user,
    p.category_name,
    p.nameen,
    vv.productid,
    sp.sku,
    sp._id
   FROM ((stg.visitors vv
     JOIN stg.subproducts sp ON ((vv.productid = sp._id)))
     JOIN stg.products p ON ((sp.productid = p._id)))
  GROUP BY vv.productid, sp.sku, sp._id, p.nameen, p.category_name
  ORDER BY (count(DISTINCT vv.userid));