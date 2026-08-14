-- my oracle sql
select customer_number 
from (
    select customer_number, 
           RANK() over (ORDER BY COUNT(order_number) DESC) as rnk
    from Orders
    group by customer_number
)
where rnk = 1;

-- others sql 1
select customer_number from (
SELECT customer_number
FROM Orders
GROUP BY customer_number order by COUNT(order_number)  desc
) where rownum = 1;