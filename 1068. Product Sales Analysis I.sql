-- my oracle sql
select 
p.product_name, s.year, s.price
from Sales s inner join Product p
on s.product_id = p.product_id

-- others sql
SELECT Product.product_name, Sales.year, Sales.price
FROM Sales
JOIN Product
ON Sales.product_id = Product.product_id;