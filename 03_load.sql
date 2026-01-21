TRUNCATE TABLE events, orders, experiment_assignments, sessions, users RESTART IDENTITY CASCADE;

\copy users(user_id, signup_ts, acquisition_channel, country) FROM 'data/generated/users.csv' CSV HEADER;
\copy sessions(session_id, user_id, session_start_ts, device) FROM 'data/generated/sessions.csv' CSV HEADER;
\copy experiment_assignments(user_id, experiment_name, variant, assigned_ts) FROM 'data/generated/experiment_assignments.csv' CSV HEADER;
\copy orders(order_id, user_id, order_ts, order_value, payment_type) FROM 'data/generated/orders.csv' CSV HEADER;
\copy events(event_id, user_id, session_id, event_ts, event_type, product_id, price) FROM 'data/generated/events.csv' CSV HEADER;

