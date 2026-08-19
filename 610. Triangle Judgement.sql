-- my oracle sql
select 
x, y, z,
case when (
GREATEST(x, y, z) <
LEAST(x, y, z) +
(case
when (GREATEST(x, y, z) != x AND LEAST(x, y, z) != x) then x
when (GREATEST(x, y, z) != y AND LEAST(x, y, z) != y) then y
else z
end)
) then 'Yes'
 else 'No'
 end
 as triangle 
from Triangle;

-- other oracle sql
select x,y,z,
 case when x+y>z 
       and y+z>x 
    and x+z>y 
  then 'Yes'
  else 'No'
  end as triangle
from Triangle;

-- other sql 2
select x,y,z, 
case
   when (x+y) <= z
     Then 'No'
   when (y+z) <= x
     Then 'No'
   when (x+z) <= y
     Then 'No'
   else 'Yes'
   end as triangle 
from Triangle ;
