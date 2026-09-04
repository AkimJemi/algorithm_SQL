-- my oracle sql
select 
s.user_id, 
round(count(case when c.action = 'confirmed' then 1 end)/ decode(count(c.action),0,1, count(c.action)),2) confirmation_rate from signups s 
left join confirmations c
on s.user_id = c.user_id
group by s.user_id;

-- others sql 1
SELECT
    S.USER_ID,
    ROUND(
        AVG(CASE WHEN C.ACTION = 'confirmed' 
        THEN 1 ELSE 0 END) , 2) AS CONFIRMATION_RATE
FROM
    SIGNUPS S
LEFT JOIN
    CONFIRMATIONS C
ON
    S.USER_ID = C.USER_ID
GROUP BY
    S.USER_ID

-- others sql 2
SELECT
    s.user_id,
    ROUND(COALESCE(c.confirm / c.total,0),2) as confirmation_rate
FROM Signups s
LEFT JOIN (
    SELECT
        user_id,
        COUNT(*) as total,
        sum(CASE WHEN action = 'confirmed' THEN 1 ELSE 0 END) as confirm
    FROM Confirmations
    GROUP BY user_id) c
ON s.user_id = c.user_id;
