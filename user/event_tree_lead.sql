 WITH ordered AS (
         SELECT user_analytics.userid,
            user_analytics.type,
            user_analytics."timestamp",
            lead(user_analytics.type, 0) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS next_event_0,
            lead(user_analytics.type, 1) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS next_event_1,
            lead(user_analytics.type, 2) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS next_event_2,
            lead(user_analytics.type, 3) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS next_event_3,
            lead(user_analytics.type, 4) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS next_event_4,
            lead(user_analytics.type, 5) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS next_event_5,
            lead(user_analytics.type, 6) OVER (PARTITION BY user_analytics.userid ORDER BY user_analytics."timestamp") AS next_event_6
           FROM stg.user_analytics
        )
 SELECT next_event_0,
    next_event_1,
    next_event_2,
    next_event_3,
    next_event_4,
    next_event_5,
    next_event_6,
    userid,
    type,
    "timestamp"
   FROM ordered;