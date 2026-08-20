-- my oralce sql
update Salary
set sex = decode(sex, 'f', 'm', 'f');

 -- others sql
update salary 
set sex= 
    case 
    when sex= 'f'then 'm'
    when sex= 'm'then 'f'
end;