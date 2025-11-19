 SELECT vv.userid AS all_user,
    p.category_name,
    p.nameen,
    p._id AS product_id,
    sp._id,
    sp.sku,
    vv."timestamp"
   FROM ((stg.visitors vv
     JOIN stg.subproducts sp ON ((vv.productid = sp._id)))
     JOIN stg.products p ON ((sp.productid = p._id)));