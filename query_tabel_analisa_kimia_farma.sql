/*
============================================================
Kimia Farma Business Performance Analysis
============================================================

Script Purpose:
    This query combines transaction, branch, and product data
    into one table for analysis.

    It is used to show:
    - Transaction details
    - Branch information
    - Product information
    - Product price
    - Discount percentage
    - Gross profit percentage
    - Net sales
    - Net profit
    - Branch rating
    - Transaction rating

Data Sources:
    - kimia_farma.kf_final_transaction
    - kimia_farma.kf_kantor_cabang
    - kimia_farma.kf_product

Main Process:
    - Join transaction data with branch data
    - Join transaction data with product data
    - Use CASE to calculate gross profit percentage
    - Calculate net sales after discount
    - Calculate net profit

Output:
    One final dataset that can be used for business analysis
    and dashboard creation in Google Looker Studio.

Note:
    This query only reads data.
    It does not change or delete the source tables.
============================================================
*/

SELECT 
  t.transaction_id,
  t.date,
  t.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  p.price AS actual_price,
  t.discount_percentage,
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price <= 100000 THEN 0.15
    WHEN p.price <= 300000 THEN 0.20
    WHEN p.price <= 500000 THEN 0.25
    ELSE 0.30
    END AS persentase_gross_laba,
  (p.price * (1 - t.discount_percentage)) AS nett_sales,
  ((p.price * (1 - t.discount_percentage)) *
    CASE 
      WHEN p.price <= 50000 THEN 0.10
      WHEN p.price BETWEEN 50001 AND 100000 THEN 0.15
      WHEN p.price BETWEEN 100001 AND 300000 THEN 0.20
      WHEN p.price BETWEEN 300001 AND 500000 THEN 0.25
      ELSE 0.30
    END) AS nett_profit,
  t.rating AS rating_transaksi
FROM `kimia_farma.kf_final_transaction` AS t
LEFT JOIN `kimia_farma.kf_kantor_cabang` AS c 
ON t.branch_id = c.branch_id
LEFT JOIN `kimia_farma.kf_product` AS p 
ON t.product_id = p.product_id;
