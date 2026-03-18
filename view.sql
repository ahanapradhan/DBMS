CREATE VIEW customer_names AS
SELECT 
    customer_id,
    first_name,
    last_name
FROM class_customers;


-- on the fly evaluation
explain (analyze, verbose)
SELECT *
FROM customer_names
WHERE customer_id < 10;


DROP VIEW IF EXISTS customer_names;
CREATE MATERIALIZED VIEW customer_names AS
SELECT 
    customer_id,
    first_name,
    last_name
FROM class_customers;
explain (analyze, verbose)
SELECT *
FROM customer_names
WHERE customer_id < 10;
