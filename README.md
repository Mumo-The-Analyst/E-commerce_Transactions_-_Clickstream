# ShopEase Online E-commerce Transactions and Clickstream Analysis in SQL and Power BI

## 1. Overview
This project analyzes how ShopEase Online, an e-commerce retailer, can leverage customer, transaction, and clickstream data to better understand user behavior and improve business performance. With online shopping becoming increasingly competitive, the company wants to uncover which factors influence how customers browse, engage, and ultimately make purchases.

Through structured SQL analysis and Power BI visualization, this project uncovers actionable insights that help ShopEase Online:

- Identify browsing patterns, conversion bottlenecks, and high-value customer segments

- Optimize marketing channels and promotional strategies

- Understand product performance and factors influencing purchase decisions

- Improve customer engagement, satisfaction, and repeat purchase behavior

By transforming raw clickstream, session, and transaction data into meaningful strategic insights, this project demonstrates how data analytics supports smarter decision-making in modern e-commerce operations.

## 2. Dataset
The dataset contains 7 tables as follows:

- Customers: customer_id, name, email, country, age, signup_date, marketing_opt_in

- Sessions: session_id, customer_id, start_time, device, source, country

- Events: event_id, session_id, timestamp, event_type, product_id, qty, cart_size, payment, discount_pct, amount_usd

- Orders: order_id, customer_id, order_time, payment_method, discount_pct, subtotal_usd, total_usd, country, device, source

- Order_Items: order_id, product_id, unit_price_usd, quantity, line_total_usd

- Products: product_id, category, name, price_usd, cost_usd, margin_usd

- Reviews: review_id, order_id, product_id, rating, review_text, review_time

## 3. Tools

- SQL – Data cleaning, preparation, and answering business questions.

- Power BI – Interactive visualizations and dashboard storytelling.
  
- GitHub – Repository for SQL scripts, documentation, dashboard files, and project write-up.
  
## 4. Exploratory Data Analysis

## 5. Data Analysis (Answering Business Questions)

## 6. Dashboard in Power BI

## 7. Business Recommendations

## 8. Conclusion
