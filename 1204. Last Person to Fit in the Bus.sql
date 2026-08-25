-- my oralce sql 
select person_name from (
select PERSON_NAME from (
select person_name, sum(weight) over(order by turn) sum_weight from Queue
order by sum_weight desc
)
where sum_weight <=1000
)
where ROWNUM = 1;

-- others sql 1
select person_name from 
(select person_name, sum(weight) over (order by turn) as max_weight from queue 
order by max_weight desc)
where max_weight <= 1000 and rownum=1;