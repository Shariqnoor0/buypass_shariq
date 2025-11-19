 WITH base AS (
         SELECT (vo.createdon)::date AS sales_date,
            vo.subproduct_id,
            sum((vo.quantity)::integer) AS qty,
            count(*) AS order_lines
           FROM stg.view_orders vo
          WHERE (vo.status <> ALL (ARRAY['cancelledByBuyer'::text, 'cancelledBySeller'::text]))
          GROUP BY (vo.createdon)::date, vo.subproduct_id
        )
 SELECT b.sales_date,
    p._id AS product_id,
    p.nameen AS product_name,
    p.seller_id,
    sum(b.qty) AS sold_qty,
    sum(b.order_lines) AS order_lines,
    count(DISTINCT b.subproduct_id) AS subproducts_sold,
    sum((COALESCE(s.stock, '0'::text))::integer) AS stock
   FROM ((base b
     JOIN stg.subproducts s ON ((s._id = b.subproduct_id)))
     JOIN stg.products p ON ((p._id = s.productid)))
  GROUP BY b.sales_date, p._id, p.nameen, p.seller_id
  ORDER BY b.sales_date, p.nameen;