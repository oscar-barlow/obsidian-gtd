## Tickler
```dataview
TASK
FROM "GTD/Tickler"
WHERE timescale <= date(today)
AND !completed
GROUP BY timescale
```

## Overdue
```dataview
TASK
FROM "GTD/Tasks"
WHERE deadline < date(today)
AND deadline != null
AND !completed
GROUP BY timescale
```

## Tasks
```dataview
TASK
FROM "GTD/Tasks"
WHERE !completed
AND timescale <= date(today)
GROUP BY project 
```
