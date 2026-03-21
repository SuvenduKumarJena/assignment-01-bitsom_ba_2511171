## Anomaly Analysis

Based on the denormalized `orders_flat.csv` file, here are the identified anomalies along with their specific data citations.

### 1. Insert Anomaly
* **Definition:** An insert anomaly occurs when certain attributes cannot be inserted into the database without the presence of other unrelated attributes.
* **Columns Cited:** `order_id` (Primary Key), `customer_id`, `customer_name`
* **Specific Row Cited:** Row 2 (`order_id`: ORD1114, `customer_id`: C001, `customer_name`: Rohan Mehta)
* **Explanation:** Because `order_id` acts as the primary key for this flat sheet, you cannot insert a brand-new customer (e.g., `C007`) or a newly hired sales representative into the database until they are associated with an actual order. The database would reject the insertion because the primary key (`order_id`) cannot be left NULL.

### 2. Update Anomaly
* **Definition:** An update anomaly occurs when data redundancy requires the same data to be updated in multiple places. If one instance is updated but others are missed, the database becomes inconsistent.
* **Columns Cited:** `order_id`, `sales_rep_id`, `office_address`
* **Specific Rows Cited:** * **Row 2:** `order_id`: ORD1114 | `sales_rep_id`: SR01 | `office_address`: "Mumbai HQ, Nariman Point, Mumbai - 400021"
  * **Row 38:** `order_id`: ORD1180 | `sales_rep_id`: SR01 | `office_address`: "Mumbai HQ, Nariman Pt, Mumbai - 400021"
* **Explanation:** There is obvious inconsistency in the `office_address` column for the exact same Sales Rep (`SR01`). In Row 2 it is spelled out as "Point", but in Row 38 it is abbreviated to "Pt". Because `SR01`'s details are repeated across dozens of rows, an administrator updating their office address would have to manually find and update every single row, risking data fragmentation if even one row is missed.

### 3. Delete Anomaly
* **Definition:** A delete anomaly occurs when deleting a row to remove one set of facts inadvertently causes the loss of other unrelated, important facts.
* **Columns Cited:** `order_id`, `product_id`, `product_name`, `unit_price`
* **Specific Row Cited:** Row 12 (`order_id`: ORD1185, `product_id`: P008, `product_name`: Webcam, `unit_price`: 2100)
* **Explanation:** Product `P008` (Webcam) is only ordered *once* in the entire dataset (in Row 12). If the customer cancels this order and we delete Row 12 (`ORD1185`) from the database, we also unintentionally delete the `product_id`, `product_name`, and `unit_price` attributes associated with the Webcam. The business would permanently lose the catalog record for this product.

## Normalization Justification

While keeping all data in a single flat file might seem simpler for generating quick, at-a-glance reports, it is fundamentally flawed for maintaining a reliable database. I respectfully refute the position that normalization is over-engineering; rather, it is essential for data integrity, accuracy, and scalability. In a denormalized system, structural data redundancy inevitably leads to critical errors.

For example, the flat dataset forces us to duplicate sales representative and customer details for every single transaction. Deepak Joshi (`SR01`) handles dozens of orders, and his office address is redundantly recorded each time. This has already caused data corruption: his address is listed as "Nariman Point" in some rows (e.g., `ORD1114`) and inconsistently abbreviated to "Nariman Pt" in others (e.g., `ORD1180`). If the company moves this office, an administrator would have to manually hunt down and update over 60 isolated rows, practically guaranteeing human error. In a normalized `sales_reps` table, this update requires changing exactly one field.

Furthermore, a flat table tightly couples independent entities, putting our core business data at risk. Product `P008` (Webcam) appears in only one order (`ORD1185`). If that customer returns the item and the order record is deleted, the company inadvertently deletes the product's ID, category, and pricing details entirely. Similarly, the company cannot add a new, unsold product to the database because it lacks an `order_id` (the primary key). 

By normalizing the database into Third Normal Form (3NF), we decouple Orders, Customers, Products, and Sales Reps into distinct tables. This is not over-engineering; it is a necessary architectural baseline that protects our catalog data, prevents update inconsistencies, and ensures the database can safely scale as the company grows.