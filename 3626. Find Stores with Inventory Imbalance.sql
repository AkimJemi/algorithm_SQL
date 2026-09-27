-- my oracle sql
with tb as (
    select store_id,
        max(quantity) keep (dense_rank first order by price desc) as max_price_qty,
        max(product_name) keep (dense_rank first order by price desc) as most_exp_product,
        max(quantity) keep (dense_rank first order by price asc) as min_price_qty,
        max(product_name) keep (dense_rank first order by price asc) as cheapest_product
    from inventory
    group by store_id
    having count (store_id) >= 3
)
select 
    tb.store_id
    , s.store_name
    , s.location
    , most_exp_product 
    , cheapest_product
    , round(min_price_qty / max_price_qty, 2) as imbalance_ratio
from tb
join stores s
    on tb.store_id = s.store_id 
where max_price_qty < min_price_qty
order by 
    imbalance_ratio desc
    , store_name asc
;

-- others sql 1
with windowed as (
    select i.*,
    row_number() over(
        partition by i.store_id
        order by i.price
    ) as rnum,
    count(*) over(
        partition by i.store_id
    ) as cnt,
    max(price) over(
        partition by i.store_id
    ) as maximum_price 
    from inventory i
)
select p.store_id, s.store_name, s.location,
max(p.most_exp_product) as most_exp_product , max(p.cheapest_product) as cheapest_product,
round(max(p.cheapQ)/ max(p.expQ),2) as imbalance_ratio
from (
    select * from (
        select store_id, case when rnum = 1 then rnum else 2 end as rnum1, product_name,
        case when rnum = 1 then quantity else null end as cheapQ,
        case when rnum > 1 then quantity else null end as expQ
        from windowed 
        where (rnum = 1 or (price = maximum_price))
        and cnt > 2
    )
    pivot(
        max(product_name)
        for rnum1 in (
            '1' as cheapest_product,
            '2' as most_exp_product 
        )
    )
) p join stores s on (p.store_id = s.store_id)
group by p.store_id, s.store_name, s.location having max(p.cheapQ)/ max(p.expQ) > 1
order by imbalance_ratio desc, s.store_name

-- others sql 2
WITH StoreStats AS (
    SELECT i.store_id,
           -- 1. Grab the total count
           COUNT(*) OVER(PARTITION BY i.store_id) AS total_products,
           
           -- 2. Grab the cheapest product info (ASC)
           FIRST_VALUE(i.product_name) OVER(
               PARTITION BY i.store_id 
               ORDER BY i.price ASC, i.product_name ASC
           ) AS cheapest_product,
           FIRST_VALUE(i.quantity) OVER(
               PARTITION BY i.store_id 
               ORDER BY i.price ASC, i.product_name ASC
           ) AS cheapQ,
           
           -- 3. Grab the most expensive product info (DESC)
           FIRST_VALUE(i.product_name) OVER(
               PARTITION BY i.store_id 
               ORDER BY i.price DESC, i.product_name ASC
           ) AS most_exp_product,
           FIRST_VALUE(i.quantity) OVER(
               PARTITION BY i.store_id 
               ORDER BY i.price DESC, i.product_name ASC
           ) AS expQ,
           
           -- 4. Keep track of row number to filter later
           ROW_NUMBER() OVER(
               PARTITION BY i.store_id 
               ORDER BY i.price ASC
           ) AS rnum
    FROM inventory i
)
SELECT s.store_id, 
       s.store_name, 
       s.location,
       st.most_exp_product, 
       st.cheapest_product,
       ROUND(st.cheapQ / st.expQ, 2) AS imbalance_ratio
FROM StoreStats st
JOIN stores s ON st.store_id = s.store_id
WHERE st.rnum = 1 
  AND st.total_products > 2
  AND (st.cheapQ / st.expQ) > 1
ORDER BY imbalance_ratio DESC, s.store_name;