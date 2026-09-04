-- my oracle sql
select * from (
select product_id, 'store1' store, store1 price from products union all
select product_id, 'store2' store, store2 price from products union all
select product_id, 'store3' store, store3 price from products 
)
where price is not null;

-- others sql 
SELECT product_id, store, price
FROM Products
UNPIVOT (
    price FOR store IN (
        store1 AS 'store1',
        store2 AS 'store2',
        store3 AS 'store3'
    )
)
WHERE price IS NOT NULL;