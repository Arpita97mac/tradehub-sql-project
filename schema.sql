-- =============================================
-- TRADEHUB DATABASE SCHEMA
-- Stock Trading Platform Database
-- =============================================

-- Create database
CREATE DATABASE IF NOT EXISTS tradehub_db;
USE tradehub_db;

-- =============================================
-- TABLE 1: USERS
-- Stores trader account information
-- =============================================
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL,
    account_balance DECIMAL(15, 2) DEFAULT 10000.00,
    risk_tolerance VARCHAR(20),  -- Conservative, Moderate, Aggressive
    country VARCHAR(50),
    phone VARCHAR(20),
    account_status VARCHAR(20) DEFAULT 'Active'  -- Active, Suspended, Closed
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- TABLE 2: STOCKS
-- Stores stock/company information
-- =============================================
CREATE TABLE stocks (
    stock_id INT PRIMARY KEY AUTO_INCREMENT,
    ticker_symbol VARCHAR(10) UNIQUE NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    sector VARCHAR(50),
    industry VARCHAR(50),
    market_cap BIGINT,
    ipo_date DATE,
    exchange VARCHAR(20),  -- NASDAQ, NYSE, etc.
    currency VARCHAR(10) DEFAULT 'USD'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- TABLE 3: STOCK_PRICES
-- Historical OHLC (Open, High, Low, Close) price data
-- =============================================
CREATE TABLE stock_prices (
    price_id INT PRIMARY KEY AUTO_INCREMENT,
    stock_id INT NOT NULL,
    price_date DATE NOT NULL,
    open_price DECIMAL(10, 4) NOT NULL,
    high_price DECIMAL(10, 4) NOT NULL,
    low_price DECIMAL(10, 4) NOT NULL,
    close_price DECIMAL(10, 4) NOT NULL,
    volume BIGINT NOT NULL,
    FOREIGN KEY (stock_id) REFERENCES stocks(stock_id),
    UNIQUE KEY unique_stock_date (stock_id, price_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- TABLE 4: TRANSACTIONS
-- Buy and sell order ledger
-- =============================================
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    stock_id INT NOT NULL,
    transaction_type VARCHAR(10) NOT NULL,  -- BUY or SELL
    transaction_date DATETIME NOT NULL,
    quantity INT NOT NULL,
    price_per_share DECIMAL(10, 4) NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL,
    commission DECIMAL(10, 2) DEFAULT 0,
    transaction_status VARCHAR(20) DEFAULT 'Completed',  -- Completed, Pending, Cancelled
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (stock_id) REFERENCES stocks(stock_id),
    CHECK (transaction_type IN ('BUY', 'SELL')),
    CHECK (quantity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- TABLE 5: PORTFOLIOS
-- Current stock holdings per user
-- =============================================
CREATE TABLE portfolios (
    portfolio_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    stock_id INT NOT NULL,
    total_shares INT NOT NULL,
    average_buy_price DECIMAL(10, 4),
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (stock_id) REFERENCES stocks(stock_id),
    UNIQUE KEY unique_user_stock (user_id, stock_id),
    CHECK (total_shares >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- TABLE 6: MARKET_INDICATORS
-- Technical analysis indicators (SMA, RSI, etc.)
-- =============================================
CREATE TABLE market_indicators (
    indicator_id INT PRIMARY KEY AUTO_INCREMENT,
    stock_id INT NOT NULL,
    calculation_date DATE NOT NULL,
    sma_50 DECIMAL(10, 4),   -- 50-day Simple Moving Average
    sma_200 DECIMAL(10, 4),  -- 200-day Simple Moving Average
    rsi DECIMAL(5, 2),       -- Relative Strength Index (0-100)
    volume_avg_30 BIGINT,    -- 30-day average volume
    FOREIGN KEY (stock_id) REFERENCES stocks(stock_id),
    UNIQUE KEY unique_stock_indicator_date (stock_id, calculation_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Index on frequently queried columns
CREATE INDEX idx_users_risk ON users(risk_tolerance);
CREATE INDEX idx_users_balance ON users(account_balance);
CREATE INDEX idx_stocks_sector ON stocks(sector);
CREATE INDEX idx_stocks_ticker ON stocks(ticker_symbol);
CREATE INDEX idx_prices_date ON stock_prices(price_date);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);

-- =============================================
-- SCHEMA SUMMARY
-- =============================================
-- Total tables: 6
-- Relationships:
--   - users → transactions (one-to-many)
--   - users → portfolios (one-to-many)
--   - stocks → stock_prices (one-to-many)
--   - stocks → transactions (one-to-many)
--   - stocks → portfolios (many-to-many via portfolios)
--   - stocks → market_indicators (one-to-many)
-- =============================================
