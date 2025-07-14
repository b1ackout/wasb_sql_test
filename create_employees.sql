USE memory.default;

DROP TABLE IF EXISTS EMPLOYEE;

CREATE TABLE EMPLOYEE (
    employee_id tinyint,
    first_name varchar(50),
    last_name varchar(50),
    job_title varchar(50),
    manager_id tinyint
);

-- Inserting data found in hr/employee_index.csv into EMPLOYEE table 
INSERT INTO
    EMPLOYEE
VALUES
    (1, 'Ian', 'James', 'CEO', 4),
    (2, 'Umberto', 'Torrielli', 'CSO', 1),
    (3, 'Alex', 'Jacobson', 'MD EMEA', 2),
    (4, 'Darren', 'Poynton', 'CFO', 2),
    (5, 'Tim', 'Beard', 'MD APAC', 2),
    (6, 'Gemma', 'Dodd', 'COS', 1),
    (7, 'Lisa', 'Platten', 'CHR', 6),
    (8, 'Stefano', 'Camisaca', 'GM Activation', 2),
    (9, 'Andrea', 'Ghibaudi', 'MD NAM', 2);