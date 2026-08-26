-- my oracle sql
select p.product_id, 
    round(sum(nvl(u.units,0) * p.price) / decode(sum(nvl(u.units,0)),0,1,sum(nvl(u.units,0))),2) as average_price
from prices p
left join unitssold u
on u.product_id = p.product_id
and u.purchase_date between p.start_date and p.end_date
group by p.product_id
;

-- others sql 1
SELECT 
    p.product_id,
    NVL(ROUND(SUM(p.price * u.units) / SUM(u.units), 2), 0) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
ON p.product_id = u.product_id
AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;

-- others sql 2
select p.product_id, round(nvl(sum(s.units * p.price)/sum(s.units),0),2) as average_price
from  prices p
left join unitssold s on s.purchase_date between p.start_date and p.end_date and p.product_id=s.product_id
group by p.product_id