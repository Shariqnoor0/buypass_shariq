 SELECT p.nameen,
    p.category_name,
    sp.sku,
    sp.price,
    sp.stock
   FROM (stg.subproducts sp
     JOIN stg.products p ON ((p._id = sp.productid)));