```dataviewjs
const activeProjects = dv.pages('"GTD/Projects"')
  .where(p => p.activationDate && !p.completionDate && p.file.folder !== "GTD/Projects/Archive" && p.urgent && p.important);

// Function to convert HSL to RGBA
function hslToRGBA(h, s, l, a) {
  h /= 360;
  let r, g, b;

  if (s === 0) {
    r = g = b = l; // achromatic
  } else {
    const hue2rgb = (p, q, t) => {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    };

    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;
    r = hue2rgb(p, q, h + 1 / 3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1 / 3);
  }

  return `rgba(${Math.round(r * 255)}, ${Math.round(g * 255)}, ${Math.round(b * 255)}, ${a})`;
}

// Generate distinct colors based on HSL
const colors = {};
const numProjects = activeProjects.length;
activeProjects.forEach((project, index) => {
  const hue = (360 / numProjects) * index;
  colors[project.file.name] = hslToRGBA(hue, 0.7, 0.6, 0.5); // Adjust saturation and lightness as needed
});

const urgentImportantData = activeProjects.map(project => ({
  x: parseInt(project.urgent),
  y: parseInt(project.important),
  label: project.file.name
}));

const chartData = {
  type: 'scatter',
  data: {
    datasets: [{
      label: 'Projects',
      data: urgentImportantData.array(),
      backgroundColor: activeProjects.map(project => colors[project.file.name]),
      borderColor: activeProjects.map(project => colors[project.file.name].replace("0.5", "1")),
      borderWidth: 1,
      pointRadius: 5,
      pointHoverRadius: 7,
      pointStyle: 'circle'
    }]
  },
  options: {
    scales: {
      x: {
        type: 'linear',
        position: 'bottom',
        min: 0,
        max: 10,
        title: {
          display: true,
          text: 'Urgency (0-10)'
        },
        grid: {
          color: (context) => context.tick.value === 5 ? 'black' : 'rgba(0, 0, 0, 0.1)',
          lineWidth: (context) => context.tick.value === 5 ? 2 : 1
        },
        padding: {
          left: 10,
          right: 10,
        },
      },
      y: {
        type: 'linear',
        position: 'left',
        min: 0,
        max: 10,
        title: {
          display: true,
          text: 'Importance (0-10)'
        },
        grid: {
          color: (context) => context.tick.value === 5 ? 'black' : 'rgba(0, 0, 0, 0.1)',
          lineWidth: (context) => context.tick.value === 5 ? 2 : 1
        },
        padding: {
          top: 10,
          bottom: 10,
        },
      }
    },
    plugins: {
      tooltip: {
        callbacks: {
          label: function(context) {
            let label = context.dataset.data[context.dataIndex].label || '';
            if (label) {
              label += ': ';
            }
            label += '(' + context.parsed.x + ', ' + context.parsed.y + ')';
            return label;
          }
        }
      }
    }
  }
};

// Apply custom styles to the chart container
this.container.style.width = '80%'; // Adjust width as needed
this.container.style.height = '600px'; // Adjust height as needed

window.renderChart(chartData, this.container);

// Create legend
dv.header(3, "Project Legend");
const legend = Object.keys(colors).map(projectName => {
  return `<span style="display:inline-block; margin-right: 10px;"><span style="display:inline-block; width: 10px; height: 10px; background-color: ${colors[projectName].replace("0.5", "1")}; margin-right: 5px;"></span>${projectName}</span>`;
}).join("");
dv.el("div", legend);

```