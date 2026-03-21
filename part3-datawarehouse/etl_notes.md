## ETL Decisions

### Decision 1 — Standardizing Date Formats
**Problem:** The raw transaction data contained highly inconsistent date formats (e.g., `29/08/2023`, `12-12-2023`, and `2023-02-05`). This prevents accurate chronological sorting, grouping by month/year, and prevents the creation of a reliable timeline for business intelligence.
**Resolution:** During the ETL pipeline, all incoming dates were parsed, standardizing them into a uniform `YYYY-MM-DD` standard date object. From there, I extracted the individual components (`year`, `month`, `day`, `quarter`) to populate `dim_date` and generated a smart integer surrogate key (`YYYYMMDD`) to act as a highly performant foreign key for `fact_sales`.

### Decision 2 — Unifying Product Categories
**Problem:** The `category` column had severe casing and nomenclature inconsistencies. The same logical category was represented as `electronics` and `Electronics`, or as `Grocery` and `Groceries`. This splits aggregations, meaning a `GROUP BY category` query would incorrectly return separate revenue lines for "Grocery" and "Groceries".
**Resolution:** I applied a text transformation step that standardized the capitalization (using Title Case) to merge `electronics` and `Electronics`. I also used a replacement mapping table to convert variations like `Groceries` into a single, canonical label (`Grocery`) before loading the unique values into the `dim_product` dimension.

### Decision 3 — Pre-calculating the Total Amount Measure
**Problem:** The raw dataset provided `units_sold` and `unit_price`, but did not include the total revenue for the transaction. While BI tools can calculate this on the fly, doing row-level multiplication for every single aggregate BI query is computationally expensive at scale.
**Resolution:** I decided to calculate `total_amount` (`units_sold` * `unit_price`) during the transformation phase and materialize it as a core numeric measure directly inside `fact_sales`. This optimizes the data warehouse for reads, ensuring that downstream queries like "Total Revenue by Month" only have to perform a simple `SUM()` rather than `SUM(units_sold * unit_price)`.