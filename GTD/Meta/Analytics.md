# Wellbeing 
## By week
This chart tracks how well I am feeling, overall, by week. The goal is to reduce variation, and to increase the mean.

```dataviewjs
const pages = dv.pages('"GTD/Meta/Weekly Reviews"')
    .sort(p => p.date);

const dates = pages.map(p => p.date.toISODate()).array();
const mentalHealths = pages.map(p => p.mentalHealth).array();

const chartData = {
    type: 'line',
    data: {
        labels: dates,
        datasets: [{
            label: 'My mental health on a 1-10 scale',
            data: mentalHealths,
            fill: true,
            borderColor: 'rgb(70, 130, 180)'
        }]
    },
    options: {
        plugins: {
            title: {
                display: true,
                text: 'Line chart of my mental health as measured at weekly reviews'
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                max: 10
            }
        }
    }
};

window.renderChart(chartData, this.container);
```

# Goals

## Project Contribution 
The chart below counts active projects contributing to active goals, and displays them as a pie chart. This allows me to see how I am apportioning my effort, and to make changes if necessary.

```dataviewjs
const goals = dv.pages('"GTD/Goals"')
    .where(goal => goal.activationDate != null && goal.activationDate <= new Date() && goal.completionDate == null);

const activeProjectLinks = dv.pages('"GTD/Projects"')
    .where(p => p.activationDate != null && p.completionDate == null && p.activationDate <= new Date())
    .map(project => project.file.link.path).array();
debugger;

const goalWithoutArchiveProjects = goals.mutate(g => g.file.inlinks = g.file.inlinks.filter(inlink => activeProjectLinks.includes(inlink.path)));

const goalNames = goalWithoutArchiveProjects.map(g => g.file.name).array();
const goalCounts = goalWithoutArchiveProjects.map(g => g.file.inlinks.length).array();

const chartData = {
    type: 'pie',
    data: {
        labels: goalNames,
        datasets: [{
            data: goalCounts,
            backgroundColor: [
                'rgb(255, 127, 80)',
                'rgb(135, 206, 235)',
                'rgb(255, 223, 0)',
                'rgb(0, 201, 87)',
                'rgb(230, 190, 255)',
                'rgb(64, 224, 208)',
                'rgb(255, 99, 71)',
            ],
            hoverOffset: 3
        }]
    },
    options: {
        plugins: {
            title: {
                display: true,
                text: 'Active projects associated with active goals'
            }
        }
    }
};

window.renderChart(chartData, this.container);
```

# Projects  

## Active By Week
This chart shows me how many active projects are ongoing per week. This gives me some objective basis to explore how busy I am versus how I feel, so that I can turn things down or up accordingly. 

```dataviewjs
const {
    DateTime
} = dv.luxon;

function createEmptyChartData(startWeek, endWeek) {
    let week = DateTime.fromISO(startDate)
    let obj = {};
    while (week <= DateTime.fromISO(endDate)) {
        obj[week.toISODate()] = 0;
        week = week.plus({
            weeks: 1
        });
    }
    return obj;
}

const activatedProjects = dv.pages('"GTD/Projects"').where(p =>
        p.activationDate != null &&
        p.activationDate <= DateTime.now() &&
        !p.file.path.includes("GTD/Projects/Unassigned"))
    .mutate(ap => {
        ap.startWeek = ap.activationDate.startOf('week');
        ap.endWeek = ap.completionDate ? ap.completionDate.startOf('week') : DateTime.now().startOf('week');
    })
    .mutate(ap => {
        let activeWeeks = [];
        ap.activeWeeks = activeWeeks;
        let week = ap.startWeek;
        while (week <= ap.endWeek) {
            activeWeeks.push(week.toISODate());
            week = week.plus({
                weeks: 1
            });
        }
    });

const allActiveProjectWeeks = activatedProjects.flatMap(ap => ap.activeWeeks);

const deduplicated = new Set(allActiveProjectWeeks.array());

const sorted = Array.from(deduplicated.values()).sort();
const startDate = sorted[0];
const endDate = sorted.slice(-1)[0];

let data = createEmptyChartData(startDate, endDate);

allActiveProjectWeeks.forEach(aPW => data[aPW] += 1);

const chartData = {
    type: 'line',
    data: {
        labels: Object.keys(data),
        datasets: [{
            label: '# active projects',
            data: Object.values(data),
            fill: false,
            borderColor: 'rgb(102, 205, 170)'
        }]
    },
    options: {
        plugins: {
            title: {
                display: true,
                text: 'Count of active projects by week'
            }
        },
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
};

window.renderChart(chartData, this.container);
```

## Length
The chart below groups projects by their duration in days, and assigns them to buckets of 10-day increments. For any new project, this helps set an expectation about how long this project should last. 

```dataviewjs
const bucketSize = 10;
const millisecondsInADay = 86400000;

function createEmptyChartData(n) {
    let obj = {};
    for (let i = 10; i <= n; i += 10) {
        obj[i] = 0;
    }
    return obj;
};

const completedProjects = dv.pages('"GTD/Projects"')
    .where(p => p.completionDate != null);
const activatedProjects = dv.pages('"GTD/Projects"')
    .where(p => p.activationDate != null && p.activationDate <= new Date() && !p.file.path.includes("GTD/Projects/Unassigned"));

const completedProjectsWithBuckets = completedProjects.mutate(cp => {
    const duration = Math.floor((cp.completionDate - cp.activationDate) / millisecondsInADay);
    const bucketFactor = Math.ceil(duration / bucketSize);
    cp.duration = duration;
    cp.bucket = bucketFactor * bucketSize;
});

const activatedProjectsWithBuckets = activatedProjects.mutate(ap => {
    const endDate = ap.completionDate ? ap.completionDate : new Date();
    const duration = Math.floor((endDate - ap.activationDate) / millisecondsInADay);
    const bucketFactor = Math.ceil(duration / bucketSize);
    ap.duration = duration;
    ap.bucket = bucketFactor * bucketSize;
});

const groupedCompletedProjectBuckets = completedProjectsWithBuckets.groupBy(cp => cp.bucket);
const groupedActivatedProjectBuckets = activatedProjectsWithBuckets.groupBy(ap => ap.bucket);

const maxCompletedBucket = groupedCompletedProjectBuckets.map(gb => gb.key).slice(-1)[0];
const maxActivatedBucket = groupedActivatedProjectBuckets.map(gb => gb.key).slice(-1)[0];
const maxBucket = Math.max(maxCompletedBucket, maxActivatedBucket);

let completedProjectData = createEmptyChartData(maxBucket);
let activatedProjectData = createEmptyChartData(maxBucket);

groupedCompletedProjectBuckets.forEach(gb => {
    completedProjectData[gb.key] = gb.rows.length
});

groupedActivatedProjectBuckets.forEach(gb => {
    activatedProjectData[gb.key] = gb.rows.length
});

const chartData = {
    type: 'bar',
    data: {
        labels: Object.keys(completedProjectData),
        datasets: [{
                label: 'Completed Project Durations',
                data: Object.values(completedProjectData),
                backgroundColor: ['rgb(170, 255, 195)']
            },
            {
                label: 'Activated (complete & incomplete) Project Durations',
                data: Object.values(activatedProjectData),
                backgroundColor: ['rgb(153, 102, 204)']
            }
        ]
    },
    options: {
        plugins: {
            title: {
                display: true,
                text: 'Histogram of project duration, 10 day buckets'
            }
        },
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
};

window.renderChart(chartData, this.container);
```

# Tasks
## Completed by Week

This chart shows how many tasks are completed by week. 

```dataviewjs
const completedTasks = dv.pages('"GTD/Tasks"')
    .flatMap(p => p.file.tasks)
    .filter(t => t.completed && t.completion);

const completedTasksWithWeekBeginnings = completedTasks.mutate(cT => {
    cT.beginningOfWeek = cT.completion
				    .startOf('day')
				    .startOf('week');
});

const completedTasksInWeekBuckets = completedTasksWithWeekBeginnings.groupBy(c => c.beginningOfWeek.toISODate());

const excludeFirstWeekBecauseIncomplete = completedTasksInWeekBuckets.slice(1, completedTasksInWeekBuckets.length);

const weekLabels = excludeFirstWeekBecauseIncomplete.key.array();

const completedTaskCounts = excludeFirstWeekBecauseIncomplete.map(c => c.rows.length).array();

const chartData = {
    type: 'line',
    data: {
        labels: weekLabels,
        datasets: [{
            label: '# of tasks completed',
            data: completedTaskCounts,
            fill: false,
            borderColor: 'rgb(204, 85, 0)'
        }]
    },
    options: {
        plugins: {
            title: {
                display: true,
                text: 'Count of tasks completed by week'
            }
        },
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
};

window.renderChart(chartData, this.container);
```