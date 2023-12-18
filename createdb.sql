CREATE SCHEMA retail
    CREATE TABLE manufacturers (
        manufacturer_id SERIAL PRIMARY KEY,
        manufacturer_name VARCHAR(100) NOT NULL
    )
    CREATE TABLE categories (
        category_id SERIAL PRIMARY KEY,
        category_name VARCHAR(100) NOT NULL
    )
    CREATE TABLE products (
        category_id BIGINT REFERENCES categories(category_id),
        manufacturer_id BIGINT REFERENCES manufacturers(manufacturer_id),
        product_id BIGINT PRIMARY KEY,
        product_name VARCHAR(255) NOT NULL
    )
    CREATE TABLE stores (
        store_id SERIAL PRIMARY KEY,
        store_name VARCHAR(255) NOT NULL
    )
    CREATE TABLE customers (
        customer_id SERIAL PRIMARY KEY,
        customer_fname VARCHAR(100) NOT NULL,
        customer_iname VARCHAR(100) NOT NULL
    )
    CREATE TABLE price_change (
        product_id BIGINT products(product_id),
        price_change_ts TIMESTAMP NOT NULL,
        new_price NUMERIC(9,2) NOT NULL
    )
    CREATE TABLE deliveries (
        store_id BIGINT REFERENCES stores(store_id),
        product_id BIGINT REFERENCES products(product_id),
        delivery_date DATE NOT NULL,
        product_count INTEGER NOT NULL
    )
    CREATE TABLE purchases (
        store_id  BIGINT REFERENCES stores(store_id),
        customer_id  BIGINT REFERENCES customers(customer_id),
        purchase_id SERIAL PRIMARY KEY NOT NULL,
        purchase_date DATETIME NOT NULL
    )
    CREATE TABLE purchase_items (
        product_id  BIGINT REFERENCES products(product_id),
        purchase_id  BIGINT REFERENCES purchases(purchase_id),
        product_count  BIGINT NOT NULL,
        product_price NUMERIC(9,2) NOT NULL
    )
    CREATE VIEW v_gmv AS (
        SELECT (
            store_id,
            category_id,
            SUM(product_count*product_price) sales_sum
        )
        FROM purchase_items 
        JOIN products USING(purchase_id)
        JOIN purchases USING(product_id)
        GROUP BY store_id, category_id
    )
    