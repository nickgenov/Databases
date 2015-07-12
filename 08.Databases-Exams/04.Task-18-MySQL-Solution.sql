USE orders;

SELECT 
	p.product as product_name, 
	count(oi.order_id) as num_orders, 
	ifnull(sum(oi.quantity), 0) as quantity,
	p.price as price,
    ifnull((p.price * sum(oi.quantity)), 0) as total_price
FROM products p
left outer join order_items oi on oi.product_id = p.id
group by p.product, p.price
order by p.product asc;

SELECT
  p.product AS product_name,
  COUNT(oi.product_id) AS num_orders,
  IFNULL(SUM(oi.quantity), 0) as quantity,
  p.price,
  IFNULL(SUM(oi.quantity) * p.price, 0) AS total_price
FROM
  products p
  LEFT JOIN order_items oi ON p.id = oi.product_id
  LEFT JOIN orders o ON oi.order_id = o.id
GROUP BY
  p.id, p.product, p.price
ORDER BY
  p.product;