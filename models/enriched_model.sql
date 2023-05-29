-- @materialize: true
SELECT 
  *,
  STR_SPLIT(page_title, ' | ')[1] AS title,
  STR_SPLIT(page_title, ' | ')[2] AS subtitle,
  CASE WHEN STR_SPLIT(eventType, '-')[-1] = 'stop' THEN 
    CAST(
    extract('second' FROM 
      event_datetime - LAG(event_datetime) OVER (PARTITION BY pageId, STR_SPLIT(eventType, '-')[1] ORDER BY event_datetime
      )
    ) 
    AS FLOAT) 
  ELSE NULL END AS duration,
  MIN(event_datetime) OVER(ORDER BY event_datetime) AS start,
  MIN(
    CASE 
      WHEN STR_SPLIT(url_split[3], '?')[1] = 'docs.rilldata.com' THEN event_datetime
      ELSE NULL END
    ) OVER(ORDER BY event_datetime) AS install,
  MIN(
    CASE 
      WHEN STR_SPLIT(url_split[3], '?')[1] = 'localhost:9009' THEN event_datetime
      ELSE NULL END
    ) OVER(ORDER BY event_datetime) AS first_run_local_example,
  MIN(
    CASE
      WHEN STR_SPLIT(url_split[3], '?')[1] = 'localhost:9009' AND STR_SPLIT(url_split[4], '?')[1]  = 'source'  AND STR_SPLIT(url_split[5], '?')[1]  ILIKE '%articles%' THEN event_datetime
      ELSE NULL END
    ) OVER (ORDER BY event_datetime) AS first_run_local_my_data,
  MIN(
    CASE 
      WHEN STR_SPLIT(url_split[3], '?')[1] = 'ui.rilldata.com' THEN event_datetime
      ELSE NULL END
    ) OVER(ORDER BY event_datetime) AS first_run_cloud,
  STR_SPLIT(url_split[3], '?')[1] AS domain,
  STR_SPLIT(url_split[4], '?')[1] AS page_1,
  STR_SPLIT(url_split[5], '?')[1] AS page_2,
  STR_SPLIT(eventType, '-')[1] AS eventClass,
  STR_SPLIT(url, '?')[2] AS query_string,
  STR_SPLIT(url, '?')[1] AS url_short,
  CASE 
    WHEN STR_SPLIT(url_split[3], '?')[1] = 'localhost:9009' THEN 'rill local'
    WHEN STR_SPLIT(url_split[3], '?')[1] = 'ui.rilldata.com' THEN 'rill cloud'
    ELSE 'website' END AS browser_state,
  STR_SPLIT(query_string, '=')[1] AS query_string_key,
  STR_SPLIT(query_string, '=')[2] AS query_string_value,
FROM unified_model
