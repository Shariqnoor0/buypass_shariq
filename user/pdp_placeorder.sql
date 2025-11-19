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
    "timestamp",
    prev_time,
    is_new_session,
    user_session_number,
    global_session_id,
    place_order_clicked_only,
    other_types_excluding_place_order,
        CASE
            WHEN (max(
            CASE
                WHEN (type = 'PLACEORDER.CLICK'::text) THEN 1
                ELSE 0
            END) OVER (PARTITION BY global_session_id) = 1) THEN 3
            WHEN (max(
            CASE
                WHEN (type = 'PRODUCT_DETAIL_VIEW'::text) THEN 1
                ELSE 0
            END) OVER (PARTITION BY global_session_id) = 1) THEN 1
            ELSE 0
        END AS session_flag
   FROM stg.v_conversion_rate_new v;