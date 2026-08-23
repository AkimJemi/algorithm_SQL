-- my orale sql
select distinct u.user_id as buyer_id, TO_CHAR(u.join_date, 'YYYY-MM-DD') as join_date, count(
    DECODE(EXTRACT(YEAR FROM NVL(o.order_date, TO_DATE('2020-01-01', 'YYYY-MM-DD'))), '2019', 1, null)) over(partition by u.user_id) as orders_in_2019
from
users u 
left join orders o
on u.user_id = o.buyer_id
left join items i
on o.item_id = i.item_id
order by 1

-- others sql 1
select user_id buyer_id, to_char(join_date , 'yyyy-mm-dd') join_date , count(*) orders_in_2019
from Users inner join Orders
on user_id =  buyer_id
where to_char(order_date, 'yyyy') = '2019'
group by user_id , to_char(join_date , 'yyyy-mm-dd')
union
select user_id buyer_id, to_char(join_date , 'yyyy-mm-dd') join_date , 0 orders_in_2019
from Users u  
where user_id not in (select buyer_id from Orders where to_char(order_date, 'yyyy') = '2019'
                  and buyer_id = u.user_id)

-- -- others sql 2
select user_id as buyer_id,to_char(join_date,'yyyy-mm-dd') as join_date, nvl(count(order_id),0) as orders_in_2019 from users u left join orders o on u.user_id=o.buyer_id and to_char(order_date,'yyyy')=2019 group by user_id, join_date order by 1;
