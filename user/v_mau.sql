 SELECT date_trunc('month'::text, ("timestamp")::timestamp without time zone) AS month,
    count(DISTINCT userid) AS mau
   FROM test.user_analytics
  GROUP BY (date_trunc('month'::text, ("timestamp")::timestamp without time zone))
  ORDER BY (date_trunc('month'::text, ("timestamp")::timestamp without time zone));