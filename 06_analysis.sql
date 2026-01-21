-- Step 6: Experiment + Core KPI analysis

-- 0) Sanity check
SELECT
  (SELECT COUNT(*) FROM users) AS users,
  (SELECT COUNT(*) FROM sessions) AS sessions,
  (SELECT COUNT(*) FROM events) AS events,
  (SELECT COUNT(*) FROM orders) AS orders,
  (SELECT COUNT(*) FROM experiment_assignments) AS experiment_users;

-- 1) What experiments/variants exist?
SELECT experiment_name, COUNT(*) AS n
FROM experiment_assignments
GROUP BY 1
ORDER BY n DESC;

SELECT variant, COUNT(*) AS n
FROM experiment_assignments
GROUP BY 1
ORDER BY n DESC;

-- 2) Pick control variant automatically:
--    If "control" exists (case-insensitive), use it; otherwise use min(variant).
WITH control AS (
  SELECT COALESCE(
    (SELECT variant FROM experiment_assignments WHERE variant ILIKE 'control' LIMIT 1),
    (SELECT MIN(variant) FROM experiment_assignments)
  ) AS control_variant
),
per_variant AS (
  SELECT
    ea.variant,
    COUNT(*) AS n_users,
    COUNT(o.order_id) FILTER (WHERE o.order_id IS NOT NULL) AS n_orders,
    COUNT(DISTINCT o.user_id) AS n_buyers,
    COALESCE(SUM(o.order_value), 0) AS revenue
  FROM experiment_assignments ea
  LEFT JOIN orders o ON o.user_id = ea.user_id
  GROUP BY 1
),
calc AS (
  SELECT
    pv.*,
    (pv.n_buyers::numeric / NULLIF(pv.n_users, 0)) AS conversion,
    (pv.revenue::numeric / NULLIF(pv.n_users, 0)) AS arpu
  FROM per_variant pv
),
joined AS (
  SELECT
    c.control_variant,
    x.*
  FROM control c
  CROSS JOIN calc x
),
ctrl AS (
  SELECT *
  FROM joined
  WHERE variant = control_variant
),
ztest AS (
  SELECT
    j.variant,
    j.n_users,
    j.n_buyers,
    j.conversion,
    j.revenue,
    j.arpu,
    (j.conversion - c.conversion) AS abs_lift,
    CASE
      WHEN c.conversion IS NULL OR c.conversion = 0 THEN NULL
      ELSE (j.conversion - c.conversion) / c.conversion
    END AS rel_lift,
    -- pooled proportion for z-test
    ((j.n_buyers + c.n_buyers)::numeric / NULLIF((j.n_users + c.n_users), 0)) AS p_pool,
    c.n_users AS n_users_control,
    c.n_buyers AS n_buyers_control,
    c.conversion AS conversion_control
  FROM joined j
  CROSS JOIN ctrl c
)
SELECT
  variant,
  n_users,
  n_buyers,
  ROUND(conversion::numeric, 6) AS conversion,
  n_users_control,
  n_buyers_control,
  ROUND(conversion_control::numeric, 6) AS conversion_control,
  ROUND(abs_lift::numeric, 6) AS abs_lift,
  ROUND(rel_lift::numeric, 6) AS rel_lift,
  ROUND(arpu::numeric, 4) AS arpu,
  ROUND(revenue::numeric, 2) AS revenue,
  CASE
    WHEN variant = (SELECT control_variant FROM (SELECT COALESCE((SELECT variant FROM experiment_assignments WHERE variant ILIKE 'control' LIMIT 1),
                                                     (SELECT MIN(variant) FROM experiment_assignments)) AS control_variant) t)
    THEN NULL
    ELSE
      -- z = (p1 - p0) / sqrt(p_pool*(1-p_pool)*(1/n0 + 1/n1))
      ROUND(
        ( (conversion - conversion_control)
          / NULLIF(
              sqrt( p_pool * (1 - p_pool) * (1.0/n_users_control + 1.0/n_users) ),
              0
          )
        )::numeric,
        4
      )
  END AS z_score_approx
FROM ztest
ORDER BY variant;

-- 3) Revenue by day (quick trend)
SELECT
  DATE(order_ts) AS day,
  COUNT(*) AS orders,
  ROUND(SUM(order_value)::numeric, 2) AS revenue
FROM orders
GROUP BY 1
ORDER BY 1;

-- 4) Event type distribution (helps define funnel next)
SELECT event_type, COUNT(*) AS n
FROM events
GROUP BY 1
ORDER BY n DESC;

