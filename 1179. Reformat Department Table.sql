-- my oracle sql
select * from (select 
distinct
id,
(select revenue from department where id = d.id and month = 'Jan') as Jan_Revenue,
(select revenue from department where id = d.id and month = 'Feb') as Feb_Revenue,
(select revenue from department where id = d.id and month = 'Mar') as Mar_Revenue,
(select revenue from department where id = d.id and month = 'Apr') as Apr_Revenue,
(select revenue from department where id = d.id and month = 'May') as May_Revenue,
(select revenue from department where id = d.id and month = 'Jun') as Jun_Revenue,
(select revenue from department where id = d.id and month = 'Jul') as Jul_Revenue,
(select revenue from department where id = d.id and month = 'Aug') as Aug_Revenue,
(select revenue from department where id = d.id and month = 'Sep') as Sep_Revenue,
(select revenue from department where id = d.id and month = 'Oct') as Oct_Revenue,
(select revenue from department where id = d.id and month = 'Nov') as Nov_Revenue,
(select revenue from department where id = d.id and month = 'Dec') as Dec_Revenue
 from department d
order by id)
where ROWNUM <= (select count(distinct id) from department);

-- others sql 1
select id,
    sum(case when month='Jan' then revenue end) as Jan_Revenue,
    sum(case when month='Feb' then revenue end) as Feb_Revenue,
    sum(case when month='Mar' then revenue end) as Mar_Revenue,
    sum(case when month='Apr' then revenue end) as Apr_Revenue,
    sum(case when month='May' then revenue end) as May_Revenue,
    sum(case when month='Jun' then revenue end) as Jun_Revenue,
    sum(case when month='Jul' then revenue end) as Jul_Revenue,
    sum(case when month='Aug' then revenue end) as Aug_Revenue,
    sum(case when month='Sep' then revenue end) as Sep_Revenue,
    sum(case when month='Oct' then revenue end) as Oct_Revenue,
    sum(case when month='Nov' then revenue end) as Nov_Revenue,
    sum(case when month='Dec' then revenue end) as Dec_Revenue
from Department
group by id;

-- others sql 2
SELECT DISTINCT
    d.id AS id,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Jan' AND d2.id = d.id) AS Jan_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Feb' AND d2.id = d.id) AS Feb_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Mar' AND d2.id = d.id) AS Mar_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Apr' AND d2.id = d.id) AS Apr_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'May' AND d2.id = d.id) AS May_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Jun' AND d2.id = d.id) AS Jun_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Jul' AND d2.id = d.id) AS Jul_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Aug' AND d2.id = d.id) AS Aug_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Sep' AND d2.id = d.id) AS Sep_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Oct' AND d2.id = d.id) AS Oct_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Nov' AND d2.id = d.id) AS Nov_Revenue,
    (SELECT d2.revenue FROM Department d2 WHERE d2.month = 'Dec' AND d2.id = d.id) AS Dec_Revenue
FROM    
    Department d