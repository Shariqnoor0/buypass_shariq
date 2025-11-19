 SELECT platform,
    ("timestamp")::date AS event_date,
    count(DISTINCT userid) AS daily_active_users
   FROM test.user_analytics
  GROUP BY ("timestamp")::date, platform
  ORDER BY ("timestamp")::date;