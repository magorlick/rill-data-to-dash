-- @materialize: true
SELECT 
  *,
  CASE 
    WHEN event_datetime >= first_run_cloud THEN 'cloud dashboard - shareable'
    WHEN event_datetime >= first_run_local_my_data THEN 'local dashboard - my data'
    WHEN event_datetime >= first_run_local_example THEN 'local dashboard - example'
    WHEN event_datetime >= start THEN 'awareness and install'
    ELSE 'other' END AS milestones, 
    DATE_DIFF('DAY', start, event_datetime) lifecycle_day_number
  FROM enriched_model
WHERE event_datetime < '2023-05-25'