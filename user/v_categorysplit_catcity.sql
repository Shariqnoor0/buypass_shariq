 SELECT p.seller_city,
    p.category_name,
    p.nameen,
    p.createdon,
    p.seller_id,
    p.seller_name,
    b.fullname,
    b.storename
   FROM ((stg.products p
     JOIN stg.categories c ON ((p.category__id = c._id)))
     JOIN stg.business b ON ((p.seller_id = b.sellerid)));