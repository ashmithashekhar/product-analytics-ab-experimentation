CREATE INDEX IF NOT EXISTS idx_sessions_user_ts
ON sessions(user_id, session_start_ts);

CREATE INDEX IF NOT EXISTS idx_events_user_ts
ON events(user_id, event_ts);

CREATE INDEX IF NOT EXISTS idx_events_session_ts
ON events(session_id, event_ts);

CREATE INDEX IF NOT EXISTS idx_events_type_ts
ON events(event_type, event_ts);

CREATE INDEX IF NOT EXISTS idx_orders_user_ts
ON orders(user_id, order_ts);

