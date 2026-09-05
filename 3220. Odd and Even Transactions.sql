-- my oracle sql 
select to_char(transaction_date,'YYYY-MM-DD') transaction_date, 
sum(case when mod(amount,2) = 1 then amount else 0 end) odd_sum, 
sum(case when mod(amount,2) = 0 then amount else 0 end) even_sum
from transactions
group by transaction_date
order by 1;