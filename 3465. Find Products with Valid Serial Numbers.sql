-- my oralce sql
select * from products 
where REGEXP_LIKE(description, '(\s|^)SN[0-9]{4}-[0-9]{4}(\s|$)', 'c')
order by product_id;