USE memory.default;

-- Create all end of month dates up to the latest invoice due date
WITH RECURSIVE end_of_months(end_of_month) AS (
    SELECT
        last_day_of_month(current_date) AS end_of_month
    UNION
    ALL
    SELECT
        last_day_of_month(end_of_month + INTERVAL '1' MONTH)
    FROM
        end_of_months
    WHERE
        end_of_month < (
            SELECT
                max(due_date)
            FROM
                INVOICE
        )
),
-- For each invoice, assign payment dates for each month before the due date
payments_per_invoice(
    supplier_id,
    supplier_name,
    invoice_amount,
    due_date,
    payment_date,
    months_to_pay
) AS (
    SELECT
        i.supplier_id,
        s.name AS supplier_name,
        i.invoice_amount,
        i.due_date,
        eom.end_of_month,
        date_diff('month', current_date, i.due_date) AS months_to_pay
    FROM
        INVOICE i
        JOIN SUPPLIER s ON s.supplier_id = i.supplier_id
        JOIN end_of_months eom ON eom.end_of_month < i.due_date
),
-- Calculate the monthly payment for each invoice and payment date
monthly_invoice_payments(
    supplier_id,
    supplier_name,
    payment_date,
    monthly_payment,
    invoice_amount
) AS (
    SELECT
        supplier_id,
        supplier_name,
        payment_date,
        invoice_amount / months_to_pay AS monthly_payment,
        invoice_amount
    FROM
        payments_per_invoice
),
-- Aggregate payments per supplier and month
supplier_monthly_payments(
    supplier_id,
    supplier_name,
    payment_date,
    payment_amount,
    total_invoices
) AS (
    SELECT
        supplier_id,
        supplier_name,
        payment_date,
        SUM(monthly_payment) AS payment_amount,
        SUM(invoice_amount) AS total_invoices
    FROM
        monthly_invoice_payments
    GROUP BY
        supplier_id,
        supplier_name,
        payment_date
),
-- Calculate balance outstanding for each supplier
final_schedule(
    supplier_id,
    supplier_name,
    payment_amount,
    payment_date,
    total_invoices,
    balance_outstanding
) AS (
    SELECT
        supplier_id,
        supplier_name,
        payment_amount,
        payment_date,
        total_invoices,
        GREATEST(
            0,
            total_invoices - SUM(payment_amount) OVER (
                PARTITION BY supplier_id
                ORDER BY
                    payment_date ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
            )
        ) AS balance_outstanding
    FROM
        supplier_monthly_payments
)
SELECT
    supplier_id,
    supplier_name,
    ROUND(payment_amount, 2) AS payment_amount,
    ROUND(balance_outstanding, 2) AS balance_outstanding,
    payment_date
FROM
    final_schedule
ORDER BY
    supplier_id,
    payment_date;