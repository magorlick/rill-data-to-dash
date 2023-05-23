-- @materialize: true

select 
  epoch_ms(CAST(COALESCE(a.createdAt, b.createdAt, c.createdAt) AS INT64)) AS event_time, 
  b.title AS page_title, 
  c.title article_title,
  COALESCE(a.pageId, b.pageId, c.pageId) AS pageId,
  * EXCLUDE(createdAt, title, pageId), 
  str_split(url, '/') AS url_split,
  str_split(page_title, '|')[1] AS title,
  str_split(page_title, '|')[2] AS subtitle,
  extract('second' FROM event_time - LAG(event_time) OVER (PARTITION BY COALESCE(a.pageId, b.pageId, c.pageId), SPLIT(eventType, '-')[1] ORDER BY event_time)) AS duration,

from events a
FULL OUTER JOIN pages b 
  ON a.pageId = b.pageId
FULL OUTER JOIN articles c
  ON a.pageId = c.pageId

ORDER BY 1