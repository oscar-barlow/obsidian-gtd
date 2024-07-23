## Inbox
```dataviewjs
const inboxItems = dv.pages('"GTD/Inbox"').file.tasks;
const unprocessed = inboxItems.where(t => !t.completed);
dv.paragraph(`You have **${unprocessed.length}** unprocessed items in your inbox`);
```
## Tickler
```dataview
TASK
FROM "GTD/Tickler"
WHERE timescale <= date(today)
AND !completed
GROUP BY timescale
```

## Due & Overdue
```dataview
TASK
FROM "GTD/Tasks"
WHERE deadline <= date(today)
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
