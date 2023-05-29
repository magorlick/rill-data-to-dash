-- @materialize: true
SELECT 
  epoch_ms(CAST(a.createdAt AS INT64)) AS event_datetime, 
  b.title AS page_title, 
  c.title article_title,
  a.pageId AS pageId,
  str_split(url, '/') AS url_split,
  * EXCLUDE(createdAt, title, pageId), 
FROM events a
LEFT JOIN pages b 
  ON a.pageId = b.pageId
LEFT JOIN articles c
  ON a.pageId = c.pageId