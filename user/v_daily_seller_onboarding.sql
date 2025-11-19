 SELECT sellerid,
    storename,
    accounttype,
        CASE
            WHEN (lower(businesstype) IS NULL) THEN 'Non Tag'::text
            ELSE businesstype
        END AS businesstype,
    status,
    country,
    address_city,
    createdon,
        CASE
            WHEN (lower(accounttype) = 'business'::text) THEN 'business'::text
            ELSE NULL::text
        END AS business_account,
        CASE
            WHEN (lower(accounttype) = 'personal'::text) THEN 'personal'::text
            ELSE NULL::text
        END AS personal_account,
        CASE
            WHEN (lower(accounttype) = 'normal'::text) THEN 'normal'::text
            ELSE NULL::text
        END AS normal_account,
    count(*) OVER (PARTITION BY sellerid) AS total_accounts
   FROM stg.business
  WHERE (isdeleted = 'false'::text)
  ORDER BY sellerid;