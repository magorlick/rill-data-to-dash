-- @materialize: true
SELECT 
  *, 
  SUM(duration) OVER(ORDER BY event_time)/60/5 AS lifecycle_five_minute,
  str_split(url_split[3], '?')[1] AS domain,
  str_split(url_split[4], '?')[1] AS page_1,
  str_split(url_split[5], '?')[1] AS page_2,
  SPLIT(eventType, '-')[1] AS eventClass,
  str_split(url, '?')[2] AS query_string,

FROM unified_model
ORDER BY pageId, SPLIT(eventType, '-')[1], event_time