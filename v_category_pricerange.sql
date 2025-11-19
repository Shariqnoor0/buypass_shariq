 SELECT p.category_name,
    count(
        CASE
            WHEN ((p.lowestprice ~ '^[0-9.]+$'::text) AND ((p.lowestprice)::numeric >= (0)::numeric) AND ((p.lowestprice)::numeric < (200)::numeric)) THEN p.category_name
            ELSE NULL::text
        END) AS "0-200",
    count(
        CASE
            WHEN ((p.lowestprice ~ '^[0-9.]+$'::text) AND ((p.lowestprice)::numeric >= (201)::numeric) AND ((p.lowestprice)::numeric < (400)::numeric)) THEN p.category_name
            ELSE NULL::text
        END) AS "200-400",
    count(
        CASE
            WHEN ((p.lowestprice ~ '^[0-9.]+$'::text) AND ((p.lowestprice)::numeric >= (401)::numeric) AND ((p.lowestprice)::numeric <= (800)::numeric)) THEN p.category_name
            ELSE NULL::text
        END) AS "400-800",
    count(
        CASE
            WHEN ((p.lowestprice ~ '^[0-9.]+$'::text) AND ((p.lowestprice)::numeric >= (801)::numeric)) THEN p.category_name
            ELSE NULL::text
        END) AS "800-Above",
    count(
        CASE
            WHEN ((p.lowestprice ~ '^[0-9.]+$'::text) AND ((p.lowestprice)::numeric >= (0)::numeric)) THEN p.category_name
            ELSE NULL::text
        END) AS total
   FROM ((stg.products p
     JOIN stg.categories c ON ((p.category__id = c._id)))
     JOIN stg.business b ON ((p.seller_id = b.sellerid)))
  GROUP BY p.category_name;