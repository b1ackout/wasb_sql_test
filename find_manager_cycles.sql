USE memory.default;

-- Recursive CTE to find cycles in the employee - manager approval chain
WITH RECURSIVE approval_cycles (employee_id, path, manager_id) AS (
    SELECT
        employee_id,
        CAST(employee_id AS VARCHAR) AS path,
        manager_id
    FROM
        EMPLOYEE
    WHERE
        manager_id IS NOT NULL
    UNION
    ALL
    SELECT
        ac.employee_id,
        CONCAT(ac.path, ',', CAST(e.employee_id AS VARCHAR)),
        e.manager_id
    FROM
        approval_cycles ac
        JOIN employee e ON ac.manager_id = e.employee_id
    WHERE
        -- Avoid immediate self-cycles
        e.employee_id != ac.employee_id
        AND POSITION(CAST(e.employee_id AS VARCHAR) IN ac.path) = 0
)
SELECT
    employee_id,
    path AS cycle
FROM
    approval_cycles
WHERE
    manager_id = employee_id
ORDER BY
    employee_id;