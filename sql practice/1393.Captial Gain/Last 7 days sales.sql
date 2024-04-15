/* To retrieve the right dataset for sales totals over the last 7 days, it's important to define the date range correctly in your SQL query. 
The key is to determine the current date and then find all records that fall within the 7-day period prior to and including today.

Here's a guide on how to correctly use comparison operators in your SQL query for calculating the total sales over the last 7 days:

### Understanding Date Comparison
- **Current Date (`CURDATE()`)**: This function gives you today's date in MySQL.
- **Interval**: You subtract 7 days from the current date to get the start of the desired period.
  
To include sales from exactly 7 days ago up to today, your condition should compare if the sale date (`sale_date`) 
is greater than or equal to 7 days ago and less than or equal to today. The correct SQL condition would be `sale_date >= CURDATE() - INTERVAL 7 DAY`.

### SQL Query to Retrieve Last 7 Days Sales Total
Here's a practical example of an SQL query that calculates the total sales from the last 7 days, 
assuming you have a table named `sales` with columns `sale_date` and `amount`:

### Explanation
1. **SELECT Clause**: This selects the sum of the `amount` field, which represents the total sales.
2. **FROM Clause**: Specifies the `sales` table as the source of data.
3. **WHERE Clause**:
   - `sale_date >= CURDATE() - INTERVAL 7 DAY`: This ensures that the sale date is not earlier than 7 days ago.
   - `sale_date <= CURDATE()`: Ensures the sale date is not later than today.

### Why Use `>=` and `<=`
- `>=`: You use greater than or equal to (`>=`) to ensure that the starting day (7 days ago) is included in your data range.
- `<=`: You use less than or equal to (`<=`) to include today in the count, ensuring that any sales occurring today are accounted for.

By setting the conditions as above, you include all sales starting from midnight 7 days ago to the end of today, covering the full 7-day period. 
This approach avoids common mistakes such as missing today's sales or starting from one day less than intended. */


SELECT
    SUM(amount) AS TotalSalesLast7Days
FROM
    sales
WHERE
    sale_date >= CURDATE() - INTERVAL 7 DAY AND
    sale_date <= CURDATE();
