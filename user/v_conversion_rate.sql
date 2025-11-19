 WITH sessionized AS (
         SELECT user_analytics.userid,
            user_analytics.type,
            user_analytics.platform,
            user_analytics.screen,
            user_analytics.os,
            user_analytics.browser,
            user_analytics.data,
            user_analytics.deviceid,
            user_analytics.adid,
            user_analytics.referer,
            user_analytics.ip,
            user_analytics.useragent,
            user_analytics.usertype,
            user_analytics."timestamp",
            lag(user_analytics."timestamp") OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS prev_time
           FROM stg.user_analytics
        ), numbered AS (
         SELECT sessionized.userid,
            sessionized.type,
            sessionized.platform,
            sessionized.screen,
            sessionized.os,
            sessionized.browser,
            sessionized.data,
            sessionized.deviceid,
            sessionized.adid,
            sessionized.referer,
            sessionized.ip,
            sessionized.useragent,
            sessionized.usertype,
            sessionized."timestamp",
            sessionized.prev_time,
            (sum(
                CASE
                    WHEN (sessionized.prev_time IS NULL) THEN 0
                    WHEN (EXTRACT(epoch FROM (sessionized."timestamp" - sessionized.prev_time)) > (1800)::numeric) THEN 1
                    ELSE 0
                END) OVER (PARTITION BY sessionized.userid ORDER BY sessionized."timestamp" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) + 1) AS session_id
           FROM sessionized
        )
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
    session_id,
        CASE
            WHEN (type = 'Place_Order_Clicked'::text) THEN type
            ELSE NULL::text
        END AS place_order_clicked_only,
        CASE
            WHEN (type <> 'Place_Order_Clicked'::text) THEN type
            ELSE NULL::text
        END AS other_types_excluding_place_order
   FROM numbered;