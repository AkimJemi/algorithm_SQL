-- my oracle sql 1
select l.ip, 
count(distinct l.ip) invalid_count
from (
    select 
    t.ip, 
    s.position, 
    s.split_value,
    case when s.split_value LIKE '0_%' then 1 else 0 end flg
    from logs t,
        XMLTABLE(
            'ora:tokenize(., "\.")'
            PASSING t.ip
            COLUMNS 
                position    FOR ORDINALITY,
                split_value VARCHAR(3) PATH '.'
        ) s
    ) l
group by l.ip
having MAX(NVL(l.position, 0)) != 4 
    or MAX(TO_NUMBER(l.split_value)) > 255
    or MAX(l.flg) = 1
order by invalid_count desc, ip desc
;
;
-- others sql 1
SELECT
    ip,
    COUNT(*) AS invalid_count
FROM logs
WHERE NOT REGEXP_LIKE(ip, '^([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]|)\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]|)\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]|)\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]|)$')
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC

-- others sql 2
WITH ip_parts AS (
    SELECT ip,
           REGEXP_SUBSTR(ip, '[^.]+', 1, 1) oct1,
           REGEXP_SUBSTR(ip, '[^.]+', 1, 2) oct2,
           REGEXP_SUBSTR(ip, '[^.]+', 1, 3) oct3,
           REGEXP_SUBSTR(ip, '[^.]+', 1, 4) oct4,
           REGEXP_COUNT(ip, '\.') + 1 octet_count
    FROM logs
),
invalid_ips AS (
    SELECT ip
    FROM ip_parts
    WHERE octet_count <> 4
       OR TO_NUMBER(oct1) > 255
       OR TO_NUMBER(oct2) > 255
       OR TO_NUMBER(oct3) > 255
       OR TO_NUMBER(oct4) > 255
       OR (LENGTH(oct1) > 1 AND SUBSTR(oct1,1,1) = '0')
       OR (LENGTH(oct2) > 1 AND SUBSTR(oct2,1,1) = '0')
       OR (LENGTH(oct3) > 1 AND SUBSTR(oct3,1,1) = '0')
       OR (LENGTH(oct4) > 1 AND SUBSTR(oct4,1,1) = '0')
)
SELECT ip,
       COUNT(*) AS invalid_count
FROM invalid_ips
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC;