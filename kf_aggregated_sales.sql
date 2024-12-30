CREATE TABLE `rakamin-kf-analytics-445613.kimia_farma.kf_aggregated_sales` AS
SELECT 
    t.transaction_id,
    t.date,
    c.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,
    -- Hitung persentase laba
    CASE 
        WHEN t.price <= 50000 THEN 10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 25
        ELSE 30
    END AS persentase_gross_laba,
    -- Hitung nett_sales
    t.price * (1 - t.discount_percentage) AS nett_sales,
    -- Hitung nett_profit
    (t.price * (1 - t.discount_percentage)) *
    (CASE 
        WHEN t.price <= 50000 THEN 10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 25
        ELSE 30
    END) / 100 AS nett_profit,
    t.rating AS rating_transaksi
FROM 
    `rakamin-kf-analytics-445613.kimia_farma.kf_final_transaction` t
LEFT JOIN 
    `rakamin-kf-analytics-445613.kimia_farma.kf_kantor_cabang` c
ON 
    t.branch_id = c.branch_id
LEFT JOIN 
    `rakamin-kf-analytics-445613.kimia_farma.kf_product` p
ON 
    t.product_id = p.product_id
ORDER BY 
    t.date;
