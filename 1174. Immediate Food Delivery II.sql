-- my oracle sql
select 
round((count(decode(ORDER_DATE,CUSTOMER_PREF_DELIVERY_DATE, 1, null))/count(*))  * 100, 2) as immediate_percentage 
from (select customer_id, order_date, customer_pref_delivery_date , row_number() over(partition by customer_id order by order_date) rn from delivery)
where rn = 1;

-- others sql 1
SELECT
    ROUND(SUM(CASE WHEN o.first_order = d.customer_pref_delivery_date THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) as immediate_percentage
FROM Delivery d
JOIN (SELECT customer_id, MIN(order_date) as first_order FROM Delivery GROUP BY customer_id) o
ON d.customer_id = o.customer_id AND d.order_date= o.first_order;

-- others sql 2
SELECT ROUND(SUM(CASE WHEN d.customer_pref_delivery_date = d.order_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS IMMEDIATE_PERCENTAGE FROM DELIVERY D JOIN
(SELECT customer_id, MIN(order_date) AS first_order FROM Delivery GROUP BY customer_id) f
ON D.CUSTOMER_ID = F.CUSTOMER_ID
AND D.ORDER_DATE = F.FIRST_ORDER;