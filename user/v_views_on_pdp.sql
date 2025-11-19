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
  WHERE (type = 'PRODUCT_DETAIL_VIEW'::text);