# 🚀 TradeHub Database - Setup Guide

Complete installation and setup instructions for the TradeHub stock trading database project.

---

## 📋 Prerequisites

- **MySQL 8.0 or higher**
- **MySQL Workbench** (recommended) or MySQL command-line client
- **At least 100MB free disk space**

---

## 🔧 Installation Steps

### Step 1: Download or Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/tradehub-sql-project.git
cd tradehub-sql-project
```

---

### Step 2: Create the Database

Open MySQL Workbench or MySQL command line and run:

```sql
CREATE DATABASE tradehub_db;
USE tradehub_db;
```

---

### Step 3: Create Tables

**Option A: Using MySQL Workbench**
1. Open `schema.sql` in MySQL Workbench
2. Click the lightning bolt icon (Execute) or press Ctrl/Cmd + Shift + Enter
3. Verify all 6 tables were created:
```sql
SHOW TABLES;
```

**Option B: Using Command Line**
```bash
mysql -u your_username -p tradehub_db < schema.sql
```

---

### Step 4: Import Sample Data

The `data/` folder contains 6 CSV files with sample data.

#### Method 1: MySQL Workbench Table Data Import Wizard (Easiest)

For each CSV file:

1. Right-click on the table name (e.g., `users`)
2. Select **"Table Data Import Wizard"**
3. Browse and select the corresponding CSV file (e.g., `data/users.csv`)
4. Click **Next**
5. Ensure **"Use existing table"** is selected
6. Click **Next** → **Next** → **Finish**

**Import in this order:**
1. ✅ users.csv → users table
2. ✅ stocks.csv → stocks table
3. ✅ stock_prices.csv → stock_prices table
4. ✅ transactions.csv → transactions table
5. ✅ portfolios.csv → portfolios table
6. ✅ market_indicators.csv → market_indicators table

#### Method 2: LOAD DATA INFILE (Command Line)

**Note:** Replace `/path/to/` with your actual file path!

```sql
USE tradehub_db;

-- Enable local file loading
SET GLOBAL local_infile = 1;

-- Import users
LOAD DATA LOCAL INFILE '/path/to/data/users.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Import stocks
LOAD DATA LOCAL INFILE '/path/to/data/stocks.csv'
INTO TABLE stocks
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Import stock_prices
LOAD DATA LOCAL INFILE '/path/to/data/stock_prices.csv'
INTO TABLE stock_prices
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Import transactions
LOAD DATA LOCAL INFILE '/path/to/data/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Import portfolios
LOAD DATA LOCAL INFILE '/path/to/data/portfolios.csv'
INTO TABLE portfolios
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Import market_indicators
LOAD DATA LOCAL INFILE '/path/to/data/market_indicators.csv'
INTO TABLE market_indicators
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

---

### Step 5: Verify Data Import

Run this verification query:

```sql
SELECT 'Users' as Table_Name, COUNT(*) as Record_Count FROM users
UNION ALL
SELECT 'Stocks', COUNT(*) FROM stocks
UNION ALL
SELECT 'Stock Prices', COUNT(*) FROM stock_prices
UNION ALL
SELECT 'Transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'Portfolios', COUNT(*) FROM portfolios
UNION ALL
SELECT 'Market Indicators', COUNT(*) FROM market_indicators;
```

**Expected Results:**
```
Users             : 100
Stocks            : 50
Stock Prices      : 13,600
Transactions      : 1,500
Portfolios        : 339
Market Indicators : 3,250
```

---

### Step 6: Test Sample Queries

Try some basic queries to ensure everything works:

```sql
-- See some users
SELECT * FROM users LIMIT 5;

-- See Technology stocks
SELECT ticker_symbol, company_name, sector
FROM stocks
WHERE sector = 'Technology'
ORDER BY market_cap DESC;

-- Latest Apple price
SELECT s.ticker_symbol, sp.price_date, sp.close_price
FROM stock_prices sp
JOIN stocks s ON sp.stock_id = s.stock_id
WHERE s.ticker_symbol = 'AAPL'
ORDER BY sp.price_date DESC
LIMIT 1;
```

---

## 📊 Running Query Examples

The `COMPLETE_QUERIES.sql` file contains 50 example queries organized by difficulty.

**To run all queries:**

```bash
mysql -u your_username -p tradehub_db < COMPLETE_QUERIES.sql
```

**Or run individual queries in MySQL Workbench:**
1. Open `COMPLETE_QUERIES.sql`
2. Select the query you want to run
3. Click Execute (lightning bolt icon)

---

## ❗ Troubleshooting

### Issue 1: "Table doesn't exist" error
**Solution:** Make sure you created the tables first using `schema.sql`

### Issue 2: "File not found" error when importing CSV
**Solution:** 
- Use absolute paths (full path from root directory)
- On Mac: `/Users/yourusername/Downloads/data/users.csv`
- On Windows: `C:/Users/yourusername/Downloads/data/users.csv`

### Issue 3: "secure-file-priv" error
**Solution:** Use MySQL Workbench's Table Data Import Wizard instead of LOAD DATA INFILE

### Issue 4: "Foreign key constraint fails"
**Solution:** Import files in the correct order:
1. Users first
2. Stocks second
3. Then all others

### Issue 5: Empty strings in datetime fields
**This is normal!** Some shipping/delivery dates are intentionally empty for pending transactions.

---

## 🎓 Next Steps

Once everything is set up:

1. **Explore the data** - Run queries from `COMPLETE_QUERIES.sql`
2. **Practice SQL** - Try modifying the queries
3. **Learn concepts** - Read query comments to understand techniques
4. **Build dashboards** - Connect to Tableau/Power BI (optional)
5. **Extend the project** - Add your own queries and analyses

---

## 📚 Documentation

- **[README.md](README.md)** - Project overview
- **[COMPLETE_QUERIES.sql](COMPLETE_QUERIES.sql)** - 50 example queries
- **[schema.sql](schema.sql)** - Database structure

---

## 🆘 Need Help?

If you encounter issues:
1. Check this troubleshooting section
2. Review MySQL error messages carefully
3. Verify file paths are correct
4. Ensure MySQL version is 8.0+
5. Check that all prerequisites are installed

---

## ✅ Installation Checklist

- [ ] MySQL 8.0+ installed
- [ ] Database `tradehub_db` created
- [ ] All 6 tables created from `schema.sql`
- [ ] All 6 CSV files imported
- [ ] Verification query shows correct record counts
- [ ] Sample queries run successfully

---

**Once complete, you're ready to explore 20,000+ records of trading data!** 🎉
