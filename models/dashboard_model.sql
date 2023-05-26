-- @materialize: true
SELECT 
  *,
  CASE 
    WHEN event_datetime > first_run_cloud THEN 'shareable cloud dashboard'
    WHEN event_datetime > first_run_local_dash THEN 'local dashboard preview'
    WHEN event_datetime > first_run_local_model THEN 'local data transformation'
    WHEN event_datetime >= start THEN 'awareness and install'
    ELSE 'other' END AS milestones, 
    DATE_DIFF('DAY', start, event_datetime) lifecycle_day_number
  FROM enriched_model
WHERE event_datetime < '2023-05-25'