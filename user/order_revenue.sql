 SELECT (revenue_sheet.tracking_number)::text AS tracking_number,
    revenue_sheet.businesstype,
    revenue_sheet.storename,
    revenue_sheet.category,
    revenue_sheet.customer_name,
    revenue_sheet.seller_city,
    revenue_sheet.user_city,
    revenue_sheet.buypassid,
    revenue_sheet.logisticpartner_title,
    revenue_sheet.base_price,
    (revenue_sheet.ind_adjustment_price)::numeric AS ind_adjustment_price,
    (revenue_sheet.ind_commission)::numeric AS ind_commission,
    (revenue_sheet.ind_buypass_profit)::numeric AS ind_buypass_profit,
    (revenue_sheet.ind_package_handling)::numeric AS ind_package_handling,
    (revenue_sheet.ind_cash_handling_fee)::numeric AS ind_cash_handling_fee,
    (revenue_sheet.ind_tax)::numeric AS ind_tax,
    (revenue_sheet.ind_product_price)::numeric AS ind_product_price,
    (revenue_sheet.ind_shipping_fee)::numeric AS ind_shipping_fee,
    (revenue_sheet.ind_vat)::numeric AS ind_vat,
    (revenue_sheet.ind_other_deductions)::numeric AS ind_other_deductions,
    (revenue_sheet.ind_product_total)::numeric AS ind_product_total,
    (revenue_sheet.calculated_shipping)::numeric AS calculated_shipping,
    revenue_sheet.order_delivery_date,
    revenue_sheet.status,
    revenue_sheet.createdon
   FROM stg.revenue_sheet
UNION ALL
 SELECT o.ecommerceshipment_consignmentno AS tracking_number,
    max(b.businesstype) AS businesstype,
    max(o.sellerdetails_storename) AS storename,
    max(o.category) AS category,
    max(o.userdetails_name) AS customer_name,
    max(o.sellerdetails_city) AS seller_city,
    max(o.userdetails_city) AS user_city,
    max(o.buypassid) AS buypassid,
    max(o.logisticpartner_title) AS logisticpartner_title,
    sum(
        CASE
            WHEN (b.businesstype = 'inclusive'::text) THEN (((o.ind_product_price)::numeric - (((((o.ind_commission)::numeric + (o.ind_adjustment_price)::numeric) + (o.ind_package_handling)::numeric) + (o.ind_cash_handling_fee)::numeric) + (o.ind_tax)::numeric)) * 0.96)
            WHEN (b.businesstype = 'exclusive'::text) THEN (((o.ind_product_price)::numeric - (((((o.ind_commission)::numeric + (o.ind_adjustment_price)::numeric) + (o.ind_package_handling)::numeric) + (o.ind_cash_handling_fee)::numeric) + (o.ind_tax)::numeric)) * 0.96)
            WHEN (b.businesstype = 'flexible'::text) THEN (((o.ind_product_price)::numeric - (((((o.ind_buypass_profit)::numeric + (o.ind_adjustment_price)::numeric) + (o.ind_package_handling)::numeric) + (o.ind_cash_handling_fee)::numeric) + (o.ind_tax)::numeric)) * 0.96)
            ELSE (0)::numeric
        END) AS base_price,
    sum((o.ind_adjustment_price)::numeric) AS ind_adjustment_price,
    sum((o.ind_commission)::numeric) AS ind_commission,
    sum((o.ind_buypass_profit)::numeric) AS ind_buypass_profit,
    sum((o.ind_package_handling)::numeric) AS ind_package_handling,
    sum((o.ind_cash_handling_fee)::numeric) AS ind_cash_handling_fee,
    sum((o.ind_tax)::numeric) AS ind_tax,
    sum((o.ind_product_price)::numeric) AS ind_product_price,
    sum((o.ind_shipping_fee)::numeric) AS ind_shipping_fee,
    sum((o.ind_vat)::numeric) AS ind_vat,
    sum((o.ind_other_deductions)::numeric) AS ind_other_deductions,
    sum((((o.ind_product_price)::numeric + (o.ind_vat)::numeric) + (o.ind_shipping_fee)::numeric)) AS ind_product_total,
    sum(((o.ind_adjustment_price)::numeric + (o.ind_shipping_fee)::numeric)) AS calculated_shipping,
    max(tw.received_datetime) AS order_delivery_date,
    max(o.sellerstatus) AS status,
    max(o.createdon) AS createdon
   FROM (((stg."order" o
     JOIN stg.business b ON ((b.sellerid = o.sellerdetails__id)))
     JOIN stg.subproducts x ON ((x._id = o.subproduct_id)))
     LEFT JOIN stg.tcs_webhook tw ON (((tw.consignmentno)::text = o.ecommerceshipment_consignmentno)))
  WHERE ((o.createdon > '2025-06-30 00:00:00'::timestamp without time zone) AND (o.createdon < '2025-10-01 00:00:00'::timestamp without time zone) AND (o.ecommerceshipment_consignmentno IS NOT NULL) AND (o.sellerstatus <> 'delivered'::text))
  GROUP BY o.ecommerceshipment_consignmentno
UNION ALL
 SELECT o.ecommerceshipment_consignmentno AS tracking_number,
    max(b.businesstype) AS businesstype,
    max(o.sellerdetails_storename) AS storename,
    max(o.category) AS category,
    max(o.userdetails_name) AS customer_name,
    max(o.sellerdetails_city) AS seller_city,
    max(o.userdetails_city) AS user_city,
    max(o.buypassid) AS buypassid,
    max(o.logisticpartner_title) AS logisticpartner_title,
    sum(
        CASE
            WHEN (b.businesstype = 'inclusive'::text) THEN (((o.ind_product_price)::numeric - (((((o.ind_commission)::numeric + (o.ind_adjustment_price)::numeric) + (o.ind_package_handling)::numeric) + (o.ind_cash_handling_fee)::numeric) + (o.ind_tax)::numeric)) * 0.96)
            WHEN (b.businesstype = 'exclusive'::text) THEN (((o.ind_product_price)::numeric - (((((o.ind_commission)::numeric + (o.ind_adjustment_price)::numeric) + (o.ind_package_handling)::numeric) + (o.ind_cash_handling_fee)::numeric) + (o.ind_tax)::numeric)) * 0.96)
            WHEN (b.businesstype = 'flexible'::text) THEN (((o.ind_product_price)::numeric - (((((o.ind_buypass_profit)::numeric + (o.ind_adjustment_price)::numeric) + (o.ind_package_handling)::numeric) + (o.ind_cash_handling_fee)::numeric) + (o.ind_tax)::numeric)) * 0.96)
            ELSE (0)::numeric
        END) AS base_price,
    sum((o.ind_adjustment_price)::numeric) AS ind_adjustment_price,
    sum((o.ind_commission)::numeric) AS ind_commission,
    sum((o.ind_buypass_profit)::numeric) AS ind_buypass_profit,
    sum((o.ind_package_handling)::numeric) AS ind_package_handling,
    sum((o.ind_cash_handling_fee)::numeric) AS ind_cash_handling_fee,
    sum((o.ind_tax)::numeric) AS ind_tax,
    sum((o.ind_product_price)::numeric) AS ind_product_price,
    sum((o.ind_shipping_fee)::numeric) AS ind_shipping_fee,
    sum((o.ind_vat)::numeric) AS ind_vat,
    sum((o.ind_other_deductions)::numeric) AS ind_other_deductions,
    sum((((o.ind_product_price)::numeric + (o.ind_vat)::numeric) + (o.ind_shipping_fee)::numeric)) AS ind_product_total,
    sum(((o.ind_adjustment_price)::numeric + (o.ind_shipping_fee)::numeric)) AS calculated_shipping,
    max(tw.received_datetime) AS order_delivery_date,
    max(o.sellerstatus) AS status,
    max(o.createdon) AS createdon
   FROM (((stg."order" o
     JOIN stg.business b ON ((b.sellerid = o.sellerdetails__id)))
     JOIN stg.subproducts x ON ((x._id = o.subproduct_id)))
     LEFT JOIN stg.tcs_webhook tw ON (((tw.consignmentno)::text = o.ecommerceshipment_consignmentno)))
  WHERE ((o.createdon > '2025-09-30 00:00:00'::timestamp without time zone) AND (o.ecommerceshipment_consignmentno IS NOT NULL))
  GROUP BY o.ecommerceshipment_consignmentno;