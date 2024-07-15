---
activationDate: 2024-03-04
completionDate:
---
## Projects
```dataviewjs
const contributingProjects = dv.current()
	.file
	.inlinks
	.filter(iL => iL.path.includes("GTD/Projects") && !iL.path.includes("Archive"));

dv.list(contributingProjects);
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
	dv.paragraph("No notes for this goal yet :(");
} else {
	dv.list(projectNotesPages);
}
```