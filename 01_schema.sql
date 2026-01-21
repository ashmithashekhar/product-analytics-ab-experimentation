DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS experiment_assignments;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id BIGINT PRIMARY KEY,
  signup_ts TIMESTAMP NOT NULL,
  acquisition_channel VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL
);

CREATE TABLE sessions (
  session_id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(user_id),
  session_start_ts TIMESTAMP NOT NULL,
  device VARCHAR(20) NOT NULL
);

CREATE TABLE experiment_assignments (
  user_id BIGINT PRIMARY KEY REFERENCES users(user_id),
  experiment_name VARCHAR(100) NOT NULL,
  variant VARCHAR(20) NOT NULL,
  assigned_ts TIMESTAMP NOT NULL
);

CREATE TABLE orders (
  order_id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(user_id),
  order_ts TIMESTAMP NOT NULL,
  order_value NUMERIC(10,2) NOT NULL,
  payment_type VARCHAR(30) NOT NULL
);

CREATE TABLE events (
  event_id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(user_id),
  session_id BIGINT NOT NULL REFERENCES sessions(session_id),
  event_ts TIMESTAMP NOT NULL,
  event_type VARCHAR(30) NOT NULL,
  product_id NUMERIC,
  price NUMERIC(10,2)
);

