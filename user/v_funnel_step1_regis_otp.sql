 SELECT DISTINCT b.phonenumber,
    b.fullname,
    b.address_city,
    b.accounttype,
    o.phonenumber AS otpphonenumber,
    b.email,
    b.status
   FROM (stg.otpcodes o
     JOIN stg.business b ON ((o.phonenumber = b.phonenumber)))
  WHERE ((o.response = '1'::text) OR (o.response = '2'::text) OR (o.response = '3'::text));