-- my oracle sql 
select * from patients
where regexp_like(conditions, '^DIAB1| DIAB1.*');

-- others sql 1
SELECT DISTINCT *
FROM Patients
WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%';
