-- @materialize: true
SELECT 
  * EXCLUDE(duration), 
CASE WHEN SPLIT(eventType, '-')[-1] = 'stop' THEN duration ELSE NULL END AS duration,
  duration AS old_duration,
  SUM(duration) OVER(ORDER BY event_datetime)/60/5 AS lifecycle_five_minute,
  MIN(event_datetime) OVER(ORDER BY event_datetime) AS start,
  MIN(CASE 
    WHEN str_split(url_split[3], '?')[1] = 'docs.rilldata.com' THEN event_datetime
    ELSE NULL END) OVER(ORDER BY event_datetime) AS install,
  MIN(CASE 
    WHEN str_split(url_split[3], '?')[1] = 'localhost:9009' THEN event_datetime
    ELSE NULL END) OVER(ORDER BY event_datetime) AS first_run_local_example,
  MIN(CASE
    WHEN str_split(url_split[3], '?')[1] = 'localhost:9009' AND str_split(url_split[4], '?')[1]  = 'source'  AND str_split(url_split[5], '?')[1]  ILIKE '%articles%' THEN event_datetime
    ELSE NULL END) OVER (ORDER BY event_datetime) AS first_run_local_my_data,
  MIN(CASE 
    WHEN str_split(url_split[3], '?')[1] = 'ui.rilldata.com' THEN event_datetime
    ELSE NULL END) OVER(ORDER BY event_datetime) AS first_run_cloud,
  str_split(url_split[3], '?')[1] AS domain,
  str_split(url_split[4], '?')[1] AS page_1,
  str_split(url_split[5], '?')[1] AS page_2,
  SPLIT(eventType, '-')[1] AS eventClass,
  str_split(url, '?')[2] AS query_string,
  str_split(url, '?')[1] AS url_short,
  CASE 
    WHEN str_split(url_split[3], '?')[1] = 'localhost:9009' THEN 'rill local'
    WHEN str_split(url_split[3], '?')[1] = 'ui.rilldata.com' THEN 'rill cloud'
    ELSE 'website' END AS browser_state,
SPLIT(query_string, '=')[1] AS query_string_key,
SPLIT(query_string, '=')[2] AS query_string_value,
FROM unified_model
ORDER BY event_datetime
