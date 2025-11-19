 WITH product_category AS (
         SELECT p._id AS product_id,
            p.seller_id,
            p.category_cateogryidpath AS productidpath,
            b.sellerid,
            b.address_city AS city
           FROM ((stg.products p
             JOIN stg.categories c ON ((p.category__id = c._id)))
             JOIN stg.business b ON ((p.seller_id = b.sellerid)))
        ), extracted_data AS (
         SELECT subquery.product_id,
            subquery.seller_id,
            subquery.sellerid,
            subquery.city,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 1)), ''''::text, ''::text), ''::text) AS col1,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 2)), ''''::text, ''::text), ''::text) AS col2,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 3)), ''''::text, ''::text), ''::text) AS col3,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 4)), ''''::text, ''::text), ''::text) AS col4,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 5)), ''''::text, ''::text), ''::text) AS col5,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 6)), ''''::text, ''::text), ''::text) AS col6,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 7)), ''''::text, ''::text), ''::text) AS col7,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 8)), ''''::text, ''::text), ''::text) AS col8,
            NULLIF(replace(TRIM(BOTH FROM split_part(subquery.cleaned_text, ','::text, 9)), ''''::text, ''::text), ''::text) AS col9
           FROM ( SELECT product_category.product_id,
                    product_category.seller_id,
                    product_category.sellerid,
                    product_category.city,
                    product_category.productidpath,
                    TRIM(BOTH '[]'::text FROM product_category.productidpath) AS cleaned_text
                   FROM product_category) subquery
        )
 SELECT e.product_id,
    e.sellerid,
    e.col1,
    c1._id,
    c1.name AS name1,
    count(
        CASE
            WHEN (e.col1 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1) AS count1,
    e.city,
    count(
        CASE
            WHEN ((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN ((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) THEN 1
            ELSE 0
        END, c1.name) AS "Islamabad_lvl1",
    count(
        CASE
            WHEN (e.city ~~* '%Karachi%'::text) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Karachi%'::text) THEN 1
            ELSE 0
        END, c1.name) AS "Karachi_lvl1",
    count(
        CASE
            WHEN (e.city ~~* '%Lahore%'::text) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Lahore%'::text) THEN 1
            ELSE 0
        END, c1.name) AS "Lahore_lvl1",
    count(
        CASE
            WHEN (e.city ~~* '%Peshawar%'::text) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Peshawar%'::text) THEN 1
            ELSE 0
        END, c1.name) AS "Peshawar_lvl1",
    count(
        CASE
            WHEN (e.city ~~* '%Rawalpindi%'::text) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Rawalpindi%'::text) THEN 1
            ELSE 0
        END, c1.name) AS "Rawalpindi_lvl1",
        CASE
            WHEN ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text)) THEN count(*) FILTER (WHERE ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text))) OVER (PARTITION BY e.city, c1.name)
            ELSE (0)::bigint
        END AS others_lvl1,
    c2.name AS name2,
    count(
        CASE
            WHEN (e.col2 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1, e.col2) AS count2,
    count(
        CASE
            WHEN ((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN ((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) THEN 1
            ELSE 0
        END, c2.name) AS "Islamabad_lvl2",
    count(
        CASE
            WHEN (e.city ~~* '%Karachi%'::text) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Karachi%'::text) THEN 1
            ELSE 0
        END, c2.name) AS "Karachi_lvl2",
    count(
        CASE
            WHEN (e.city ~~* '%Lahore%'::text) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Lahore%'::text) THEN 1
            ELSE 0
        END, c2.name) AS "Lahore_lvl2",
    count(
        CASE
            WHEN (e.city ~~* '%Peshawar%'::text) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Peshawar%'::text) THEN 1
            ELSE 0
        END, c2.name) AS "Peshawar_lvl2",
    count(
        CASE
            WHEN (e.city ~~* '%Rawalpindi%'::text) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Rawalpindi%'::text) THEN 1
            ELSE 0
        END, c2.name) AS "Rawalpindi_lvl2",
        CASE
            WHEN ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text)) THEN count(*) FILTER (WHERE ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text))) OVER (PARTITION BY e.city, c2.name)
            ELSE (0)::bigint
        END AS others_lvl2,
    c3.name AS name3,
    count(
        CASE
            WHEN (e.col3 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1, e.col2, e.col3) AS count3,
    count(
        CASE
            WHEN (((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) AND (c3.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN ((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) THEN 1
            ELSE 0
        END, c3.name) AS "Islamabad_lvl3",
    count(
        CASE
            WHEN ((e.city ~~* '%Karachi%'::text) AND (c3.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Karachi%'::text) THEN 1
            ELSE 0
        END, c3.name) AS "Karachi_lvl3",
    count(
        CASE
            WHEN ((e.city ~~* '%Lahore%'::text) AND (c3.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Lahore%'::text) THEN 1
            ELSE 0
        END, c3.name) AS "Lahore_lvl3",
    count(
        CASE
            WHEN ((e.city ~~* '%Peshawar%'::text) AND (c3.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Peshawar%'::text) THEN 1
            ELSE 0
        END, c3.name) AS "Peshawar_lvl3",
    count(
        CASE
            WHEN ((e.city ~~* '%Rawalpindi%'::text) AND (c3.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Rawalpindi%'::text) THEN 1
            ELSE 0
        END, c3.name) AS "Rawalpindi_lvl3",
        CASE
            WHEN ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text)) THEN count(*) FILTER (WHERE ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text) AND (c3.name IS NOT NULL))) OVER (PARTITION BY e.city, c3.name)
            ELSE (0)::bigint
        END AS others_lvl3,
    c4.name AS name4,
    count(
        CASE
            WHEN (e.col4 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1, e.col2, e.col3, e.col4) AS count4,
    count(
        CASE
            WHEN (((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) AND (c4.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN ((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) THEN 1
            ELSE 0
        END, c4.name) AS "Islamabad_lvl4",
    count(
        CASE
            WHEN ((e.city ~~* '%Karachi%'::text) AND (c4.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Karachi%'::text) THEN 1
            ELSE 0
        END, c4.name) AS "Karachi_lvl4",
    count(
        CASE
            WHEN ((e.city ~~* '%Lahore%'::text) AND (c4.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Lahore%'::text) THEN 1
            ELSE 0
        END, c4.name) AS "Lahore_lvl4",
    count(
        CASE
            WHEN ((e.city ~~* '%Peshawar%'::text) AND (c4.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Peshawar%'::text) THEN 1
            ELSE 0
        END, c4.name) AS "Peshawar_lvl4",
    count(
        CASE
            WHEN ((e.city ~~* '%Rawalpindi%'::text) AND (c4.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Rawalpindi%'::text) THEN 1
            ELSE 0
        END, c4.name) AS "Rawalpindi_lvl4",
        CASE
            WHEN ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text)) THEN count(*) FILTER (WHERE ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text) AND (c4.name IS NOT NULL))) OVER (PARTITION BY e.city, c4.name)
            ELSE (0)::bigint
        END AS others_lvl4,
    c5.name AS name5,
    count(
        CASE
            WHEN (e.col5 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1, e.col2, e.col3, e.col4, e.col5) AS count5,
    count(
        CASE
            WHEN (((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) AND (c5.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN ((e.city ~~* '%G - 8%'::text) OR (e.city ~~* '%G - 9%'::text) OR (e.city ~~* '%G - 13%'::text) OR (e.city ~~* '%I - 8%'::text)) THEN 1
            ELSE 0
        END, c5.name) AS "Islamabad_lvl5",
    count(
        CASE
            WHEN ((e.city ~~* '%Karachi%'::text) AND (c5.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Karachi%'::text) THEN 1
            ELSE 0
        END, c5.name) AS "Karachi_lvl5",
    count(
        CASE
            WHEN ((e.city ~~* '%Lahore%'::text) AND (c5.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Lahore%'::text) THEN 1
            ELSE 0
        END, c5.name) AS "Lahore_lvl5",
    count(
        CASE
            WHEN ((e.city ~~* '%Peshawar%'::text) AND (c5.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Peshawar%'::text) THEN 1
            ELSE 0
        END, c5.name) AS "Peshawar_lvl5",
    count(
        CASE
            WHEN ((e.city ~~* '%Rawalpindi%'::text) AND (c5.name IS NOT NULL)) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY
        CASE
            WHEN (e.city ~~* '%Rawalpindi%'::text) THEN 1
            ELSE 0
        END, c5.name) AS "Rawalpindi_lvl5",
        CASE
            WHEN ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text)) THEN count(*) FILTER (WHERE ((e.city IS NOT NULL) AND (e.city !~~* '%G - 8%'::text) AND (e.city !~~* '%G - 9%'::text) AND (e.city !~~* '%G - 13%'::text) AND (e.city !~~* '%I - 8%'::text) AND (e.city !~~* '%Karachi%'::text) AND (e.city !~~* '%Lahore%'::text) AND (e.city !~~* '%Peshawar%'::text) AND (e.city !~~* '%Rawalpindi%'::text) AND (c5.name IS NOT NULL))) OVER (PARTITION BY e.city, c4.name)
            ELSE (0)::bigint
        END AS others_lvl5,
    c6.name AS name6,
    count(
        CASE
            WHEN (e.col6 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1, e.col2, e.col3, e.col4, e.col5, e.col6) AS count6,
    c7.name AS name7,
    count(
        CASE
            WHEN (e.col7 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1, e.col2, e.col3, e.col4, e.col5, e.col6, e.col7) AS count7,
    c8.name AS name8,
    count(
        CASE
            WHEN (e.col8 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1, e.col2, e.col3, e.col4, e.col5, e.col6, e.col7, e.col8) AS count8,
    c9.name AS name9,
    count(
        CASE
            WHEN (e.col9 IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) OVER (PARTITION BY e.col1, e.col2, e.col3, e.col4, e.col5, e.col6, e.col7, e.col8, e.col9) AS count9
   FROM (((((((((extracted_data e
     LEFT JOIN stg.categories c1 ON ((e.col1 = (('"'::text || c1._id) || '"'::text))))
     LEFT JOIN stg.categories c2 ON ((e.col2 = (('"'::text || c2._id) || '"'::text))))
     LEFT JOIN stg.categories c3 ON ((e.col3 = (('"'::text || c3._id) || '"'::text))))
     LEFT JOIN stg.categories c4 ON ((e.col4 = (('"'::text || c4._id) || '"'::text))))
     LEFT JOIN stg.categories c5 ON ((e.col5 = (('"'::text || c5._id) || '"'::text))))
     LEFT JOIN stg.categories c6 ON ((e.col6 = (('"'::text || c6._id) || '"'::text))))
     LEFT JOIN stg.categories c7 ON ((e.col7 = (('"'::text || c7._id) || '"'::text))))
     LEFT JOIN stg.categories c8 ON ((e.col8 = (('"'::text || c8._id) || '"'::text))))
     LEFT JOIN stg.categories c9 ON ((e.col9 = (('"'::text || c9._id) || '"'::text))));