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
        ), session_flags AS (
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
                CASE
                    WHEN (sessionized.prev_time IS NULL) THEN 1
                    WHEN (EXTRACT(epoch FROM (sessionized."timestamp" - sessionized.prev_time)) > (1800)::numeric) THEN 1
                    ELSE 0
                END AS is_new_session
           FROM sessionized
        ), session_groups AS (
         SELECT session_flags.userid,
            session_flags.type,
            session_flags.platform,
            session_flags.screen,
            session_flags.os,
            session_flags.browser,
            session_flags.data,
            session_flags.deviceid,
            session_flags.adid,
            session_flags.referer,
            session_flags.ip,
            session_flags.useragent,
            session_flags.usertype,
            session_flags."timestamp",
            session_flags.prev_time,
            session_flags.is_new_session,
            sum(session_flags.is_new_session) OVER (PARTITION BY session_flags.userid ORDER BY session_flags."timestamp" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS user_session_number
           FROM session_flags
        ), distinct_sessions AS (
         SELECT DISTINCT session_groups.userid,
            session_groups.user_session_number
           FROM session_groups
        ), global_sessions AS (
         SELECT distinct_sessions.userid,
            distinct_sessions.user_session_number,
            row_number() OVER (ORDER BY distinct_sessions.userid, distinct_sessions.user_session_number) AS global_session_id
           FROM distinct_sessions
        ), final AS (
         SELECT sg.userid,
            sg.type,
            sg.platform,
            sg.screen,
            sg.os,
            sg.browser,
            sg.data,
            sg.deviceid,
            sg.adid,
            sg.referer,
            sg.ip,
            sg.useragent,
            sg.usertype,
            sg."timestamp",
            sg.prev_time,
            sg.is_new_session,
            sg.user_session_number,
            gs.global_session_id
           FROM (session_groups sg
             JOIN global_sessions gs ON (((sg.userid = gs.userid) AND (sg.user_session_number = gs.user_session_number))))
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
    is_new_session,
    user_session_number,
    global_session_id,
        CASE
            WHEN (type = 'PLACEORDER.CLICK'::text) THEN 'Order Placed'::text
            ELSE 'No Order Placed'::text
        END AS place_order_clicked_only,
        CASE
            WHEN (type <> 'PLACEORDER.CLICK'::text) THEN type
            ELSE NULL::text
        END AS other_types_excluding_place_order
   FROM final;