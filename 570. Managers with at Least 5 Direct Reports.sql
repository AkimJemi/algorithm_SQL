/* Write your PL/SQL query statement below */
with direct AS (
    select * from Employee where managerID is null)
, manager AS (
    select * from Employee manager where managerID is not null
)
SELECT m.*, d.*, COUNT(d.id) OVER (PARTITION BY m.id) AS COUNT_t 
FROM manager m 
LEFT JOIN direct d ON m.managerID = d.id;