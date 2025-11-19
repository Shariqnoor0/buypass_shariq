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
  WHERE (type = ANY (ARRAY['STARSHOP.CLICK'::text, 'Home_Banner_Clicked'::text, 'HOME.VIEW'::text, 'STARSHOP.CLICK'::text, 'CATEGORY.CLICK'::text, 'SHEEL.CLICK'::text, 'HORIZONTALPRODUCT.VIEW'::text, 'VERTICALPRODUCT.VIEW'::text, 'PRODUCT.REMOVEWISHLIST'::text, 'PRODUCT.ADDWISHLIST'::text, 'CATEGORIES.SECTION.VIEW'::text, 'ADDRESS.CLICK'::text, 'CART.CLICK'::text, 'PRODUCT.CLICK'::text, 'SEARCHPRODUCT.CLICK'::text, 'PRODUCT_DETAIL_VIEW'::text, 'WISHLIST.VIEW'::text, 'PRODUCT.CLICK'::text, 'CATEGORY.CLICK'::text]));