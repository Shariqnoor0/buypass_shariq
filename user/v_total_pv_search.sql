 SELECT userid,
    type,
    platform,
    browser,
    deviceid,
    "timestamp"
   FROM stg.user_analytics
  WHERE (type = 'SEARCHPRODUCT.CLICK'::text);