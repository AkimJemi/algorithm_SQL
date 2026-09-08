with max_tb as (
    select 
        case 
        when to_char(s.sale_date, 'MM') between '03' and '05' then 'Spring' 
        when to_char(s.sale_date, 'MM') between '06' and '08' then 'Summer' 
        when to_char(s.sale_date, 'MM') between '09' and '11' then 'Fall' 
        when to_char(s.sale_date, 'MM') in ('12', '01', '02') then 'Winter' 
        end season,
        p.category,
        sum(s.quantity) total_quantity,
        sum(s.quantity * s.price) total_revenue
    from sales s
    inner join products p
    on s.product_id = p.product_id
    group by 
    case 
        when to_char(s.sale_date, 'MM') between '03' and '05' then 'Spring' 
        when to_char(s.sale_date, 'MM') between '06' and '08' then 'Summer' 
        when to_char(s.sale_date, 'MM') between '09' and '11' then 'Fall' 
        when to_char(s.sale_date, 'MM') in ('12', '01', '02') then 'Winter' 
    end, p.category
) 
-- select season, category, max(total_revenue) tr from max_tb group by season, category
select mt.*
from max_tb mt
inner join (select season, max(total_revenue) tr from max_tb group by season) sb
on mt.season = sb.season
and mt.total_revenue = sb.tr
order by mt.season;