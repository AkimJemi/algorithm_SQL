with f_e_tb as ( 
    select distinct
        driver_id
        , sum(case when extract(month from trip_date) between 1 and 6 then distance_km / fuel_consumed end) / decode(count(case when extract(month from trip_date) between 1 and 6 then distance_km / fuel_consumed end), 0, 1, count(case when extract(month from trip_date) between 1 and 6 then distance_km / fuel_consumed end)) as first_half_avg
        , sum(case when extract(month from trip_date) between 7 and 12 then distance_km / fuel_consumed end) /decode(count(case when extract(month from trip_date) between 7 and 12 then distance_km / fuel_consumed end), 0, 1, count(case when extract(month from trip_date) between 7 and 12 then distance_km / fuel_consumed end)) as second_half_avg
    from trips 
    group by driver_id
)
select
    f.driver_id
    , d.driver_name
    , round(f.first_half_avg, 2) first_half_avg
    , round(f.second_half_avg, 2) second_half_avg
    , round(f.second_half_avg - f.first_half_avg,2) efficiency_improvement
from f_e_tb f
inner join drivers d
on f.driver_id = d.driver_id
where 
    first_half_avg is not null
    and second_half_avg is not null
    and second_half_avg > first_half_avg
order by efficiency_improvement desc, driver_name asc


-- others sql 1
select driver_id,driver_name,first_half_avg,second_half_avg,efficiency_improvement
from
(
select driver_id,

driver_name,

round(sum(
    case 
        when half='first' then distance_km/fuel_consumed
    end
)/count(
     case 
        when half='first' then 1
    end
),2)as first_half_avg,

round(sum(
    case 
        when half='second' then distance_km/fuel_consumed
    end
)/count(
     case 
        when half='second' then 1
    end
),2)as second_half_avg,

round(
sum(
    case 
        when half='second' then distance_km/fuel_consumed
    end
)/count(
     case 
        when half='second' then 1
    end
)-sum(
    case 
        when half='first' then distance_km/fuel_consumed
    end
)/count(
     case 
        when half='first' then 1
    end
),2) as efficiency_improvement

from (
    select driver_id,
    driver_name,
    trip_id,
    trip_date,
    distance_km,
    fuel_consumed,
    case 
        when extract (month from trip_date) between 1 and 6 then 'first'
        else 'second'
    end as half
    from drivers d
    join trips t
    using (driver_id)
)
group by driver_id,driver_name
)
where first_half_avg is not null and second_half_avg is not null and second_half_avg>first_half_avg
order by efficiency_improvement desc,driver_name
 
 -- others sql 2
 select driver_id, driver_name, 
round(first_half_avg,2) first_half_avg, 
round(second_half_avg,2) second_half_avg, 
round(second_half_avg-first_half_avg, 2) efficiency_improvement 
from (
select d.driver_id,driver_name, 
avg(case when to_char(trip_date,'mm') < '07' then distance_km/fuel_consumed end) first_half_avg,
avg(case when to_char(trip_date,'mm') >= '07' then distance_km/fuel_consumed end) second_half_avg
from drivers d, trips t
where d.driver_id = t.driver_id
group by d.driver_id,driver_name)
where second_half_avg > first_half_avg
order by efficiency_improvement desc, driver_name