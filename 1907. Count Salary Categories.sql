-- my oracle sql
select category, count(category) - 1 as accounts_count
from (
select 
account_id,
case 
when income < 20000 then 'Low Salary'
when income > 50000 then 'High Salary'
else 'Average Salary' end category
from accounts
union all select null, 'Low Salary' category from dual
union all select null, 'Average Salary' category from dual
union all select null, 'High Salary' category from dual
)
group by category
;

-- others sql 1
select 'High Salary' as category, count(case when income>50000 then 1 end) as accounts_count
from Accounts
union all
select 'Low Salary' as category, count(case when income<20000 then 1 end) as accounts_count
from Accounts
union all
select 'Average Salary' as category, count(case when income between 20000 and 50000 then 1 end) as accounts_count
from Accounts

-- others sql 2
select 'Low Salary' as category , count(account_id) as  accounts_count from accounts where income <20000
union 
select 'Average Salary' as category , count(account_id) as  accounts_count from accounts where income between 20000 and 50000
union
select 'High Salary' as category , count(account_id) as  accounts_count from accounts where income > 50000;