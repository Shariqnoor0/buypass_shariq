 WITH ordered AS (
         SELECT user_analytics.userid,
            user_analytics.type,
            user_analytics."timestamp",
            lag(user_analytics.type, 0) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS prev_event_0,
            lag(user_analytics.type, 1) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS prev_event_1,
            lag(user_analytics.type, 2) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS prev_event_2,
            lag(user_analytics.type, 3) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS prev_event_3,
            lag(user_analytics.type, 4) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS prev_event_4,
            lag(user_analytics.type, 5) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS prev_event_5,
            lag(user_analytics.type, 6) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS prev_event_6
           FROM stg.user_analytics
        )
 SELECT userid,
    type,
    "timestamp",
    prev_event_0,
    prev_event_1,
    prev_event_2,
    prev_event_3,
    prev_event_4,
    prev_event_5,
    prev_event_6
   FROM ordered;