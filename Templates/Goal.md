---
activationDate: {{date}}
completionDate:
---
## Contributing Projects
### Active
```dataviewjs
const {
    DateTime
} = dv.luxon;

const activeProjectLinks = dv.pages('"GTD/Projects"')
    .where(p => p.activationDate != null && p.completionDate == null && p.activationDate <= DateTime.now())
    .map(project => project.file.link.path);

const activeContributingProjects = dv.current()
	.file
	.inlinks
	.filter(iL => activeProjectLinks.includes(iL.path));

dv.list(activeContributingProjects);
```

### Inactive
```dataviewjs
const {
    DateTime
} = dv.luxon;

const inactiveProjectLinks = dv.pages('"GTD/Projects"')
    .where(p => p.activationDate == null || p.activationDate > DateTime.now())
    .map(project => project.file.link.path);

const inactiveContributingProjects = dv.current()
	.file
	.inlinks
	.filter(iL => inactiveProjectLinks.includes(iL.path));

dv.list(inactiveContributingProjects);
```

### Completed
```dataviewjs
const {
    DateTime
} = dv.luxon;

const completedProjectLinks = dv.pages('"GTD/Projects"')
    .where(p => p.completionDate != null)
    .map(project => project.file.link.path);

const completedContributingProjects = dv.current()
	.file
	.inlinks
	.filter(iL => completedProjectLinks.includes(iL.path));

dv.list(completedContributingProjects);
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