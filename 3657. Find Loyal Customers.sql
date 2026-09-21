-- my oracle sql
select customer_id from customer_transactions
group by customer_id
having max(transaction_date) - min(transaction_date) >= 30
and count(*) > 2
and (count(case when transaction_type = 'refund' then 1 end) / count(*))*100 < 20
order by customer_id

-- others sql 1
select customer_id
from customer_transactions
group by customer_id 
having sum(case when transaction_type = 'purchase' then 1 else 0 end) >=3 
and max(transaction_date) - min(transaction_date) >= 30
and avg(case when transaction_type = 'refund' then 1 else 0 end) < 0.2
order by customer_id
