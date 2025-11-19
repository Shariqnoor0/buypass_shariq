 SELECT (o.createdon)::timestamp without time zone AS date,
    o.buypassid AS order_id,
    ro.id AS return_order_id,
    o.product_name AS product_title,
        CASE
            WHEN (o.quantity ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.quantity)::numeric
            ELSE (0)::numeric
        END AS quantity,
    (o.weight)::numeric AS weight,
    o.logisticpartner_title AS delivery_partner,
    o.order_type AS delivery_type,
    o.paymentmethoddata_shortname AS mode_of_payment,
    o.sellerdetails_city AS seller_city,
    o.userdetails_city AS buyer_city,
    o.sellerdetails__id AS seller_id,
    b.businesstype,
        CASE
            WHEN (o.price ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.price)::numeric
            ELSE (0)::numeric
        END AS original_price,
        CASE
            WHEN (o.special_price ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.special_price)::numeric
            ELSE (0)::numeric
        END AS special_price,
        CASE
            WHEN (o.ind_adjustment_price ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.ind_adjustment_price)::numeric
            ELSE (0)::numeric
        END AS adjusted_amount,
        CASE
            WHEN (o.overall_shipping_fee ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.overall_shipping_fee)::numeric
            ELSE (0)::numeric
        END AS delivery_fee,
        CASE
            WHEN (o.ind_commission ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.ind_commission)::numeric
            ELSE (0)::numeric
        END AS buypass_commission,
        CASE
            WHEN (o.ind_package_handling ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.ind_package_handling)::numeric
            ELSE (0)::numeric
        END AS package_handling_fee,
        CASE
            WHEN (o.ind_cash_handling_fee ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.ind_cash_handling_fee)::numeric
            ELSE (0)::numeric
        END AS cash_handling_fee,
        CASE
            WHEN (o.ind_vat ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.ind_vat)::numeric
            ELSE (0)::numeric
        END AS vat,
    (
        CASE
            WHEN (o.ind_adjustment_price ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.ind_adjustment_price)::numeric
            ELSE (0)::numeric
        END +
        CASE
            WHEN (o.overall_shipping_fee ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.overall_shipping_fee)::numeric
            ELSE (0)::numeric
        END) AS logistics_payout,
        CASE
            WHEN (o.ind_buypass_profit ~ '^\s*-?\d+(\.\d+)?\s*$'::text) THEN (o.ind_buypass_profit)::numeric
            ELSE (0)::numeric
        END AS buypass_profit
   FROM ((stg.view_orders o
     LEFT JOIN stg.business b ON ((o.sellerdetails__id = b.sellerid)))
     LEFT JOIN stg.return_orders ro ON ((ro.orderid = o._id)))
  WHERE ((o.createdon)::timestamp without time zone > '2025-07-01 00:00:00'::timestamp without time zone);