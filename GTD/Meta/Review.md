## Upcoming Projects 

## Active Projects 

### Without tasks
```dataviewjs
const tasks = dv.pages('"GTD/Tasks"').file.tasks;
const incompleteTasks = tasks.where(t => !t.completed);

debugger;

const projectsWithTasksPaths = incompleteTasks.map(t => t.project.path)
    .distinct();

const activeProjects = dv.pages('"GTD/Projects"')
    .where(p => p.activationDate != null && p.completionDate == null && p.activationDate <= new Date())
    .sort(p => p.activationDate)
    .map(p => p.file.link);

const activeProjectsWithoutIncompleteTasks = activeProjects.filter(p => !projectsWithTasksPaths.includes(p.path));

dv.list(activeProjectsWithoutIncompleteTasks);
```

### Without completed task in last 2 weeks 
```dataviewjs
const millisecondsInADay = 86400000;
const today = new Date();
const twoWeeksAgo = today - (14 * millisecondsInADay);

const tasks = dv.pages('"GTD/Tasks"').file.tasks;
const completeTasksLessThan2WeeksAgo = tasks.where(t => t.completed && t.completion >= twoWeeksAgo);
const projectsWithCompletedTasksLessThan2WeeksAgoPaths = completeTasksLessThan2WeeksAgo.map(t => t.project.path)
	.distinct();

const activeProjects = dv.pages('"GTD/Projects"')
	.where(p => p.activationDate != null && p.completionDate == null && p.activationDate <= new Date())
	.sort(p => p.activationDate)
	.map(p => p.file.link);

const activeProjectsWithoutTasksCompletedInLast2Weeks = activeProjects.filter(p => !projectsWithCompletedTasksLessThan2WeeksAgoPaths.includes(p.path));

dv.list(activeProjectsWithoutTasksCompletedInLast2Weeks);
```