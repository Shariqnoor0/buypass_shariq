 WITH cohort_retention AS (
         SELECT ct.cohort_month,
            ct.m0,
            ct.m1,
            ct.m2,
            ct.m3,
            ct.m4,
            ct.m5,
            ct.m6,
            ct.m7,
            ct.m8,
            ct.m9,
            ct.m10,
            ct.m11,
            ct.m12
           FROM crosstab('
        SELECT
            to_char(date_trunc(''month'', u.createdon), ''YYYY-MM'') AS cohort_month,
            ''m'' || (
                EXTRACT(MONTH FROM age(date_trunc(''month'', a.timestamp), date_trunc(''month'', u.createdon))) +
                (EXTRACT(YEAR FROM age(date_trunc(''month'', a.timestamp), date_trunc(''month'', u.createdon))) * 12)
            )::int AS month_key,
            COUNT(DISTINCT u.userid) AS returning_users
        FROM stg.keycloak_users u
        JOIN stg.user_analytics a ON u.userid = a.userid
        WHERE a.timestamp >= u.createdon
        GROUP BY cohort_month, month_key
        ORDER BY cohort_month, month_key
        '::text, '
        SELECT ''m'' || generate_series::text
        FROM generate_series(0, 12)
        '::text) ct(cohort_month text, m0 integer, m1 integer, m2 integer, m3 integer, m4 integer, m5 integer, m6 integer, m7 integer, m8 integer, m9 integer, m10 integer, m11 integer, m12 integer)
        ), signup_counts AS (
         SELECT to_char(date_trunc('month'::text, keycloak_users.createdon), 'YYYY-MM'::text) AS cohort_month,
            count(*) AS total_signups
           FROM stg.keycloak_users
          GROUP BY (to_char(date_trunc('month'::text, keycloak_users.createdon), 'YYYY-MM'::text))
        )
 SELECT r.cohort_month,
    s.total_signups,
    r.m0,
    r.m1,
    r.m2,
    r.m3,
    r.m4,
    r.m5,
    r.m6,
    r.m7,
    r.m8,
    r.m9,
    r.m10,
    r.m11,
    r.m12
   FROM (cohort_retention r
     LEFT JOIN signup_counts s ON ((r.cohort_month = s.cohort_month)))
  ORDER BY r.cohort_month;