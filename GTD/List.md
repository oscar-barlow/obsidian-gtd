# Goals
```dataviewjs
const goals = dv.pages('"GTD/Goals"')
	.where(g => g.activationDate != null && g.completionDate == null)
	.sort(g => g.activationDate, 'asc');

dv.table(["#", "Goal", "Activation Date"], goals.map((goal, index) => [index + 1, goal.file.link, goal.activationDate.toISODate()]));
```

# Active Projects

```dataviewjs
const pages = dv.pages('"GTD/Projects"')
  .where(p => p.activationDate != null && p.completionDate == null && p.activationDate <= new Date())
  .sort(p => p.activationDate, 'asc');

// Initialize the table
dv.table(["#", "Project", "Activation Date"],
  pages.map((page, index) => [index + 1, page.file.link, page.activationDate.toISODate()]));
```

# Inactive projects 

```dataviewjs
const pages = dv.pages('"GTD/Projects"')
  .where(p => (p.activationDate == null || p.activationDate > new Date()) && p.completionDate == null)
  .sort(p => p.file.link, 'asc');

// Initialize the table
dv.table(["#", "Project", "Activation Date"],
  pages.map((page, index) => [index + 1, page.file.link, page.activationDate ? page.activationDate.toISODate() : "Not set"]));
```


# Completed Projects

```dataviewjs
const pages = dv.pages('"GTD/Projects"')
  .where(p => p.activationDate != null && p.completionDate != null)
  .sort(p => p.completionDate, 'asc');

// Initialize the table
dv.table(["#", "Project", "Completion Date"],
  pages.map((page, index) => [index + 1, page.file.link, page.completionDate.toISODate()]));
```

