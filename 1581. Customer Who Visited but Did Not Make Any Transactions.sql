-- my oracle sql
select v.customer_id, count(*) as count_no_trans
from visits v left join
transactions t
on v.visit_id = t.visit_id
where t.amount IS NULL
group by v.customer_id

-- others sql 1
SELECT customer_id, COUNT(visit_id) as count_no_trans
FROM Visits
WHERE visit_id 
NOT IN (
    SELECT visit_id 
    FROM Transactions)
GROUP BY Customer_id
