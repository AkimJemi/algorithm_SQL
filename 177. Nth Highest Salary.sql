-- my sql
CREATE FUNCTION getNthHighestSalary(N IN NUMBER) RETURN NUMBER IS
result NUMBER;
BEGIN
    SELECT salary INTO result
    FROM (
        SELECT DISTINCT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank 
        FROM employee
    )
    WHERE salary_rank = N;

    RETURN result;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;

-- other sql
CREATE FUNCTION getNthHighestSalary(N IN NUMBER) RETURN NUMBER IS
result NUMBER;
BEGIN
SELECT  DISTINCT salary  INTO result FROM 
(SELECT salary,DENSE_RANK() OVER (ORDER BY salary DESC) R 
FROM  Employee) WHERE R = N;
RETURN result;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;