## Storage Systems

For this project, I decided to use different types of databases depending on what the system needs to do. Using just one standard database for everything would cause major performance issues.

* **Predicting Risk & Monthly Reports (Goals 1 & 3):** I chose a **Data Warehouse** (like Snowflake or BigQuery). To predict readmission risks or calculate monthly department costs, the system has to scan millions of old patient records. If we tried to run these massive calculations on the hospital's main daily database, it would slow everything down. A data warehouse is specifically built to handle heavy, complex queries on historical data without freezing.
* **Plain English Doctor Queries (Goal 2):** I chose a **Vector Database** (like Pinecone). A normal SQL database only searches for exact word matches. If a doctor asks about a "heart attack," a normal database might miss a file that says "cardiac event." A vector database stores text based on its meaning, allowing the AI to understand the context of the doctor's question and find the right patient history even if the exact words don't match.
* **Streaming ICU Vitals (Goal 4):** I chose a **Time-Series Database** (like InfluxDB). ICU machines send heart rate and blood pressure updates every single second. Standard databases struggle and bottleneck when trying to save non-stop, rapid-fire updates. A time-series database is designed exactly for this: it easily absorbs non-stop streams of timestamped data and lets us quickly show a live chart to the doctors.

## OLTP vs OLAP Boundary

The boundary between the live hospital operations (OLTP) and our analytical AI system (OLAP) happens at the data extraction phase. 

The "live" side includes the hospital's main EHR system, the billing system, and the live ICU devices. These systems need to be fast and reliable because hospital staff rely on them to treat patients right now. 

The "analytical" side includes our Data Warehouse and Vector Database. This is where we run the AI models and generate big reports. 

The boundary between them is maintained by our data pipelines. We pull a copy of the data from the live systems and move it into our analytical databases. This separation is extremely important. It means that when hospital management runs a giant end-of-month financial report, it runs on the Data Warehouse. This guarantees that our heavy AI and reporting tasks will never accidentally slow down or crash the live EHR system that doctors are actively using.

## Trade-offs

**Trade-off: System Complexity**
The biggest trade-off in my design is how complicated it is. By choosing to use a Time-Series database, a Vector database, and a Data Warehouse, the system will perform really well, but there are a lot of moving parts. Having multiple databases means the engineering team has to write more code to connect them, and there are more places where a data pipeline could break. If the pipeline between the EHR and the Vector database stops working, the AI won't have the latest patient notes to answer doctor questions.

**Mitigation:**
To handle this complexity, the best approach is to use fully managed cloud services instead of trying to host all these databases on our own local hospital servers. By using cloud tools, the cloud provider handles the background server maintenance and backups. I would also add an automated monitoring tool that sends an alert to the IT team if any data stops moving between the systems, so we can fix it before the doctors even notice a problem.