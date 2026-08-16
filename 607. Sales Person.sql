-- my oracle sql
select s.name from salesperson s 
where not exists (
select * from
orders o
inner join company c
on o.com_id = c.com_id
where s.sales_id = o.sales_id
and c.name = 'RED'
);


-- others sql 1
select
    name
from salesperson
where sales_id not in(
    select
        o.sales_id
    from orders o
    join company c
        on o.com_id = c.com_id
    where c.name = 'RED'
);
-- others sql 2
SELECT NAME FROM SALESPERSON WHERE SALES_ID NOT IN (
    SELECT O.sales_id 
    FROM ORDERS O 
    JOIN COMPANY C
    ON O.COM_ID = C.COM_ID
    WHERE C.NAME = 'RED');

-- others sql 3
select s.name from Salesperson s minus
select s.name   from SalesPerson  s left join Orders  o
on s.sales_id=o.sales_id where  exists ( select 1 from Company c where o.com_id=c.com_id and c.name ='RED');