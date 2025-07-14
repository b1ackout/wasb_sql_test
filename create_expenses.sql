USE memory.default;

DROP TABLE IF EXISTS EXPENSE;

CREATE TABLE EXPENSE (
    employee_id tinyint,
    unit_price decimal(8, 2),
    quantity tinyint
);

-- Inserting data found in finance/receipts_from_last_night into EXPENSE table
INSERT INTO
    EXPENSE
VALUES
    (3, 6.50, 14),
    (3, 11.00, 20),
    (3, 22.00, 18),
    (3, 13.00, 75),
    -- Here the unit price was integer, but seems valid expense, converted to decimal
    (9, 300.00, 1),
    (4, 40.00, 9),
    (2, 17.50, 4);