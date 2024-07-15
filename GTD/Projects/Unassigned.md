---
activationDate: 1970-01-01
completionDate:
---

## Supporting Goals
* Update me

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