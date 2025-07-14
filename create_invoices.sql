USE memory.default;

DROP TABLE IF EXISTS INVOICE;

CREATE TABLE INVOICE (
    supplier_id TINYINT,
    -- Corrected typo from README (invoice_ammount -> invoice_amount)
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

DROP TABLE IF EXISTS SUPPLIER;

CREATE TABLE SUPPLIER (supplier_id TINYINT, name VARCHAR(50));

INSERT INTO
    SUPPLIER (supplier_id, name)
SELECT
    -- Assigns IDs 1,2,3,etc in alphabetical order
    ROW_NUMBER() OVER (ORDER BY name ASC) AS supplier_id, 
    name
FROM (
    VALUES
        ('Catering Plus'),
        ('Dave''s Discos'),
        ('Entertainment tonight'),
        ('Ice Ice Baby'),
        ('Party Animals')
) AS t (name);

-- Insert invoices for each supplier, mapping supplier names to supplier_id
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
SELECT
    s.supplier_id,
    tmp.invoice_amount,
    -- Calculate due_date as the last day of the month, X months from today
    CASE
        WHEN tmp.due_date_months = 1 THEN LAST_DAY_OF_MONTH(CURRENT_DATE + INTERVAL '1' MONTH)
        WHEN tmp.due_date_months = 2 THEN LAST_DAY_OF_MONTH(CURRENT_DATE + INTERVAL '2' MONTH)
        WHEN tmp.due_date_months = 3 THEN LAST_DAY_OF_MONTH(CURRENT_DATE + INTERVAL '3' MONTH)
        WHEN tmp.due_date_months = 6 THEN LAST_DAY_OF_MONTH(CURRENT_DATE + INTERVAL '6' MONTH)
    END AS due_date
FROM (
    VALUES
        ('Party Animals', 6000.00, 3),
        ('Catering Plus', 2000.00, 2),
        ('Catering Plus', 1500.00, 3),
        ('Dave''s Discos', 500.00, 1),
        ('Entertainment tonight', 6000.00, 3),
        ('Ice Ice Baby', 4000.00, 6)
) AS tmp (supplier_name, invoice_amount, due_date_months)
INNER JOIN SUPPLIER s ON s.name = tmp.supplier_name;
