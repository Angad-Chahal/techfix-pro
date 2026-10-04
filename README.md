# TechFix Pro – IT Service & Device Repair Database

A relational database built in **Oracle SQL** for a fictional IT repair business that services laptops, phones, tablets, and other devices. Built as a team project for **CNIT 27200 – Database Fundamentals** at Purdue University Indianapolis.

## Overview

TechFix Pro tracks the full lifecycle of a repair: customers and business clients, their devices, appointments, repair tickets, technicians, parts and suppliers, invoices, and payments.

- **14 tables** with primary and foreign key relationships
- **140+ rows** of sample data (10 per table)
- Full script runs top to bottom in Oracle SQL Developer (DROP → CREATE → ALTER → INSERT)

## Database Tables

| Area | Tables |
|---|---|
| Customers | `customer`, `business_client` |
| Devices & scheduling | `device`, `appointment` |
| Repairs | `repair_ticket`, `service_type`, `work_assignment`, `technician` |
| Inventory | `part`, `supplier`, `supplier_part`, `ticket_part` |
| Billing | `invoice`, `payment` |

`supplier_part`, `ticket_part`, and `work_assignment` are junction tables that resolve many-to-many relationships (for example, a repair ticket can use many parts, and a part can be used on many tickets).

## My Role

I led the SQL implementation:

- Converted the team's ERD into DDL (`CREATE`, `ALTER`, and `DROP` statements)
- Defined primary and foreign keys across all 14 tables
- Wrote the `INSERT` statements and loaded data in parent-to-child order to maintain referential integrity
- Tested the full script and validated results with `SELECT` and `DESCRIBE` queries

## Challenges & Solutions

| Challenge | Solution |
|---|---|
| Foreign key errors when creating tables | Reordered table creation from parent to child |
| Duplicate primary key errors on re-runs | Added `DROP TABLE` statements so the script runs cleanly from the top |
| Oracle's 30-character name limit | Shortened constraint names (e.g., `wa_ticket_fk`) |
| Inserts failing on missing referenced rows | Inserted parent table data before child tables |

## Repository Contents

| File | What it contains |
|---|---|
| `teamXX_milestone2.sql` | Full script: DROP, CREATE, ALTER, and INSERT statements |
| `DESCRIBEstatements.txt` | DESCRIBE output showing each table's structure |
| `selectstatements.txt` | SELECT output verifying the loaded data |
| `CNIT 27200 Phase 2 Activity Report` | Team activity report |

## How to Run

1. Open `teamXX_milestone2.sql` in Oracle SQL Developer.
2. Run the full script (F5).
3. Use `DESCRIBE <table_name>;` or `SELECT * FROM <table_name>;` to explore the data.

## Team

- **Angad Chahal** – SQL implementation, data loading, testing
- **Ayomide Obisesan** – ERD design and schema review
- **Israel Awoyungbo** – Sample data creation and output validation

*All data in this project is fictional sample data.*
