---
activationDate: 2024-01-26
completionDate: 2024-02-23
---

## Supporting Goals
* [[Renovate the House]]

## Tasks 
```dataview
TASK
WHERE !completed
AND project = this.file.link
GROUP BY timescale 
```

## Notes
```dataviewjs
const currentPage = dv.current();
const fileName = currentPage.file.name;

const tag = fileName.replaceAll(/[\s\-]/g, '_')
	.replaceAll("'", "")
	.toLowerCase();
	
const projectNotesPages = dv.pages(`#${tag}`)
	.sort(p => p.file.mtime)
	.map(p => p.file.link);

if (projectNotesPages.length == 0) {
	dv.paragraph("No notes for this project yet :(");
} else {
	dv.list(projectNotesPages);
}
```