 SELECT userid,
    type,
    platform,
    screen,
    os,
    browser,
    data,
    deviceid,
    adid,
    referer,
    ip,
    useragent,
    usertype,
    "timestamp"
   FROM stg.user_analytics
  WHERE (type = ANY (ARRAY['PRODUCT_DETAIL_VIEW'::text, 'PRODUCT.ADDWISHLIST'::text, 'PRODUCT.REMOVEWISHLIST'::text, 'PRODUCT.SHARE'::text, 'VARIANTS.CLICK'::text, 'VOUCHERS.VIEW'::text, 'REVIEWS.VIEW'::text, 'STORE_DETAIL_VIEW'::text, 'STOREDETAIL.VISITSTORE'::text, 'ALTERNATIVEPRODUCTS.VIEW'::text, 'ALTERNATIVEPRODUCTS.VIEWALL'::text, 'PRODUCT.ADDTOCART'::text, 'COMPLEMENTARYPRODUCTS.VIEW'::text, 'COMPLEMENTARYPRODUCTS.VIEWALL'::text, 'JUSTFORYOU.VIEW'::text, 'PRODUCT.ADDTOCART'::text, 'PRODUCT.BUYNOW'::text]));