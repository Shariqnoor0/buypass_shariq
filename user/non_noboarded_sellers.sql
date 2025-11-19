 SELECT b.accounttype,
    b.address_city,
    b.address_shopname,
    b.businesstype,
    b.buypassid,
    b.createdon,
    b.email,
    b.phonenumber,
    b.sellerid,
    b.status,
    b.sellertype,
    b.storename
   FROM (stg.business b
     LEFT JOIN stg.products p ON ((b.sellerid = p.seller_id)))
  WHERE ((p.seller_id IS NULL) AND (b.isdeleted = 'false'::text));