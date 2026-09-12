-- my oracle sql
with least_tb as (
    select patient_id from covid_tests
    group by patient_id
    having 
    count(case when result = 'Positive' then 1 end) >= 1 and
    count(case when result = 'Negative' then 1 end) >= 1
),
p_tb as (
    select
        patient_id,
        min(test_date) test_date
    from 
    covid_tests c 
    where exists (select * from least_tb where c.patient_id = patient_id)
    and result = 'Positive'
    group by patient_id
),
n_tb as (
    select
        c.patient_id,
        min(c.test_date) test_date
    from 
    covid_tests c 
    inner join p_tb p 
    on c.patient_id = p.patient_id
    where result = 'Negative'
    and c.test_date > p.test_date
    group by c.patient_id
)
select
    p.patient_id,
    pt.patient_name,
    pt.age,
    n.test_date - p.test_date recovery_time
from p_tb p 
inner join n_tb n
on p.patient_id = n.patient_id
inner join patients pt
on p.patient_id = pt.patient_id
order by recovery_time asc, patient_name asc

-- others sql
SELECT
    p.patient_id,
    pt.patient_name,
    pt.age,
    MIN(n.test_date) - MIN(p.test_date) AS recovery_time
FROM covid_tests p
JOIN covid_tests n
    ON p.patient_id = n.patient_id
   AND p.result = 'Positive'
   AND n.result = 'Negative'
   AND n.test_date > p.test_date
JOIN patients pt
    ON pt.patient_id = p.patient_id
GROUP BY
    p.patient_id,
    pt.patient_name,
    pt.age
ORDER BY
    recovery_time,
    pt.patient_name;

-- others sql 2
WITH POSITIVE_DATE AS (
    select PATIENT_ID, TEST_DATE AS POSITIVE_DATE, 
    ROW_NUMBER() OVER (PARTITION BY PATIENT_ID ORDER BY test_date) AS RN
    from covid_tests
    where result = 'Positive'
), POSITIVE_DATE_HEAD_1 AS (
    SELECT * FROM POSITIVE_DATE WHERE RN = 1
), NEGATIVE_DATE AS (
    SELECT PATIENT_ID, TEST_DATE, POSITIVE_DATE, 
    TEST_DATE - POSITIVE_DATE AS RECOVERY_TIME,
    ROW_NUMBER() OVER (PARTITION BY PATIENT_ID ORDER BY test_date) AS RN
    FROM COVID_TESTS INNER JOIN POSITIVE_DATE_HEAD_1 USING (PATIENT_ID)
    WHERE RESULT = 'Negative'
    AND POSITIVE_DATE < TEST_DATE
), NEGATIVE_DATE_HEAD_1 AS (
    SELECT * FROM NEGATIVE_DATE
    WHERE RN = 1
)
-- SELECT * FROM NEGATIVE_DATE
SELECT PATIENT_ID, PATIENT_NAME, AGE, RECOVERY_TIME 
FROM NEGATIVE_DATE_HEAD_1 INNER JOIN PATIENTS USING (PATIENT_ID) 
ORDER BY RECOVERY_TIME, PATIENT_NAME