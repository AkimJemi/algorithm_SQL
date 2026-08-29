-- my oracle sql
select b.stock_name, sell_sum - buy_sum as capital_gain_loss  from
(select stock_name, sum(price) buy_sum from stocks where operation = 'Buy' group by stock_name) b
inner join 
(select stock_name, sum(price) sell_sum from stocks where operation = 'Sell' group by stock_name) s
on b.stock_name = s.stock_name

-- others sql 1
select 
    stock_name,
    sum(
        case
         when operation='Buy' then -price
         when operation='Sell'then price
        end


    ) as capital_gain_loss
from
    stocks
group by
    stock_name;