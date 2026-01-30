// Color palette matching the R dashboard
const colorPalette = {
    primary: '#25408F',
    secondary: '#B94700',
    accent: '#FFD41C',
    light: '#9098CF',
    gender: ['#FFD41C', '#6ECAC8'],
    race: ['#E69F00', '#56B4E9', '#009E73', '#F0E442', '#0072B2', '#D55E00', '#CC79A7', '#000000'],
    multiColor: ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#7f7f7f']
};

let globalData = [];
let currentTab = 'totals';
let chartInstance = null;
let currentSortField = 'Year';
let currentSortOrder = 'desc';

// Initialize dashboard
async function initDashboard() {
    // Load data
    globalData = await dataLoader.loadDataFromCSV();
    
    // Setup event listeners
    setupTabListeners();
    setupResetButton();
    setupTableSortControls();
    setupTableHeaderSorting();
    
    // Render initial view
    renderView('totals');
}

// Setup table sort controls
function setupTableSortControls() {
    const sortField = document.getElementById('sortField');
    const sortOrder = document.getElementById('sortOrder');
    if (!sortField || !sortOrder) return;

    sortField.value = currentSortField;
    sortOrder.value = currentSortOrder;

    sortField.addEventListener('change', () => {
        currentSortField = sortField.value;
        updateTableHeaderArrows();
        renderTable(dataLoader.filterData(globalData, { class: getClassForTab(currentTab) }));
    });

    sortOrder.addEventListener('change', () => {
        currentSortOrder = sortOrder.value;
        updateTableHeaderArrows();
        renderTable(dataLoader.filterData(globalData, { class: getClassForTab(currentTab) }));
    });
}

function getClassForTab(tab) {
    switch(tab) {
        case 'totals': return 'Totals';
        case 'gender': return 'Gender';
        case 'race': return 'Race';
        case 'age': return 'Age';
        case 'employment': return 'Employee_Status';
        case 'event': return 'Causes';
        case 'industry': return 'Industry';
        case 'occupation': return 'Occupation';
        default: return '';
    }
}

// Update table headers with sort arrows
function updateTableHeaderArrows() {
    const thYear = document.getElementById('th-year');
    const thLabel = document.getElementById('table-col-label');
    const thCount = document.getElementById('th-count');
    
    if (!thYear || !thLabel || !thCount) return;

    // Get base text for each header (remove any existing arrows)
    const getText = (th) => th.innerHTML.replace(/\s*[▲▼↕]/g, '');
    
    const yearText = getText(thYear);
    const labelText = getText(thLabel);
    const countText = getText(thCount);

    // Add appropriate arrows to all columns
    const directionArrow = currentSortOrder === 'asc' ? ' ▲' : ' ▼';
    const neutralArrow = ' ↕';

    thYear.innerHTML = yearText + (currentSortField === 'Year' ? directionArrow : neutralArrow);
    thLabel.innerHTML = labelText + (currentSortField === 'Label' ? directionArrow : neutralArrow);
    thCount.innerHTML = countText + (currentSortField === 'Count' ? directionArrow : neutralArrow);
}

// Setup clickable table header sorting (toggles order on repeated clicks)
function setupTableHeaderSorting() {
    const thYear = document.getElementById('th-year');
    const thLabel = document.getElementById('table-col-label');
    const thCount = document.getElementById('th-count');
    if (!thYear || !thLabel || !thCount) return;

    function applyHeaderClick(element, field) {
        element.style.cursor = 'pointer';
        element.addEventListener('click', () => {
            if (currentSortField === field) {
                currentSortOrder = currentSortOrder === 'asc' ? 'desc' : 'asc';
            } else {
                currentSortField = field;
                currentSortOrder = 'desc';
            }

            // update select controls if present
            const sf = document.getElementById('sortField');
            const so = document.getElementById('sortOrder');
            if (sf) sf.value = currentSortField;
            if (so) so.value = currentSortOrder;

            updateTableHeaderArrows();
            renderTable(dataLoader.filterData(globalData, { class: getClassForTab(currentTab) }));
        });
    }

    applyHeaderClick(thYear, 'Year');
    applyHeaderClick(thLabel, 'Label');
    applyHeaderClick(thCount, 'Count');
    
    // Initial arrow display
    updateTableHeaderArrows();
}

// Setup tab navigation
function setupTabListeners() {
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const tab = this.dataset.tab;
            
            // Update active tab
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            // Render new view
            renderView(tab);
        });
    });
}

// Setup reset button
function setupResetButton() {
    document.getElementById('reset-btn').addEventListener('click', function() {
        document.querySelectorAll('.tab-btn')[0].click();
    });
}

// Render view based on tab selection
function renderView(tab) {
    currentTab = tab;
    
    let data = [];
    let title = '';
    let colors = [];
    
    switch(tab) {
        case 'totals':
            data = dataLoader.filterData(globalData, { class: 'Totals' });
            title = 'California Fatal Occupational Injuries Within the Scope of CFOI (1999-2023)';
            colors = [colorPalette.primary];
            renderLineChart(data, title, colors);
            break;
            
        case 'gender':
            data = dataLoader.filterData(globalData, { class: 'Gender' });
            title = 'California Fatal Occupational Injuries by Gender (2009-2023)';
            colors = colorPalette.gender;
            renderMultiLineChart(data, title, colors);
            break;
            
        case 'race':
            data = dataLoader.filterData(globalData, { class: 'Race' });
            title = 'California Fatal Occupational Injuries by Race/Ethnicity (2009-2023)';
            colors = colorPalette.multiColor;
            renderMultiLineChart(data, title, colors);
            break;
            
        case 'age':
            data = dataLoader.filterData(globalData, { class: 'Age' });
            title = 'California Fatal Occupational Injuries by Age Group (2013-2023)';
            colors = colorPalette.multiColor;
            renderMultiLineChart(data, title, colors);
            break;
            
        case 'employment':
            data = dataLoader.filterData(globalData, { class: 'Employee_Status' });
            title = 'California Fatal Occupational Injuries by Employment Status (2009-2023)';
            colors = colorPalette.gender;
            renderMultiLineChart(data, title, colors);
            break;
            
        case 'event':
            data = dataLoader.filterData(globalData, { class: 'Causes' });
            title = 'California Fatal Occupational Injuries by Fatal Event (2013-2023)';
            colors = colorPalette.multiColor;
            renderMultiLineChart(data, title, colors);
            break;
            
        case 'industry':
            data = dataLoader.filterData(globalData, { class: 'Industry' });
            title = 'California Fatal Occupational Injuries by Industry (2013-2023)';
            colors = colorPalette.multiColor;
            renderMultiLineChart(data, title, colors);
            break;
            
        case 'occupation':
            data = dataLoader.filterData(globalData, { class: 'Occupation' });
            title = 'California Fatal Occupational Injuries by Occupation (2013-2023)';
            colors = colorPalette.multiColor;
            renderMultiLineChart(data, title, colors);
            break;
    }
    
    // Update titles
    document.getElementById('chart-title').textContent = title;
    document.getElementById('table-title').textContent = title;
    
    // Update table column header
    let columnLabel = 'Category';
    if (tab === 'totals') columnLabel = 'Type';
    else if (tab === 'gender') columnLabel = 'Gender';
    else if (tab === 'race') columnLabel = 'Race/Ethnicity';
    else if (tab === 'age') columnLabel = 'Age Group';
    else if (tab === 'employment') columnLabel = 'Employment Status';
    else if (tab === 'event') columnLabel = 'Fatal Event Type';
    else if (tab === 'industry') columnLabel = 'Industry';
    else if (tab === 'occupation') columnLabel = 'Occupation';
    
    document.getElementById('table-col-label').textContent = columnLabel;
    
    // Render table
    renderTable(data);
}

// Render line chart for single series (Totals)
function renderLineChart(data, title, colors) {
    const ctx = document.getElementById('mainChart').getContext('2d');
    
    const years = data.map(d => d.Year);
    const counts = data.map(d => d.Count);
    
    // Destroy previous chart if it exists
    if (chartInstance) {
        chartInstance.destroy();
    }
    
    chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: years,
            datasets: [{
                label: 'Total Fatalities',
                data: counts,
                borderColor: colors[0],
                backgroundColor: colors[0] + '20',
                borderWidth: 3,
                pointBackgroundColor: colors[0],
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 5,
                pointHoverRadius: 7,
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: { size: 14, weight: 'bold' },
                    bodyFont: { size: 13 },
                    displayColors: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 700,
                    ticks: {
                        font: { size: 12, weight: 'bold' }
                    },
                    grid: {
                        color: '#e0e0e0'
                    }
                },
                x: {
                    ticks: {
                        font: { size: 12, weight: 'bold' }
                    },
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
    
    // Update summary stats
    updateSummaryStats(data);
}

// Render line chart for multiple series
function renderMultiLineChart(data, title, colors) {
    const ctx = document.getElementById('mainChart').getContext('2d');
    
    // Group data by label
    const grouped = dataLoader.groupByLabel(data);
    // Use unique, sorted years for the x-axis to avoid duplicate year labels
    const labels = [...new Set(data.map(d => d.Year))].sort((a, b) => a - b);
    const uniqueLabels = dataLoader.getUniqueValues(data, 'Label');
    
    // Create datasets
    const datasets = uniqueLabels.map((label, idx) => {
        const categoryData = grouped[label] || [];
        const countsByYear = {};
        categoryData.forEach(d => {
            countsByYear[d.Year] = d.Count;
        });
        
        return {
            label: label,
            data: labels.map(year => countsByYear[year] || 0),
            borderColor: colors[idx % colors.length],
            backgroundColor: colors[idx % colors.length] + '20',
            borderWidth: 2.5,
            pointBackgroundColor: colors[idx % colors.length],
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 4,
            pointHoverRadius: 6,
            tension: 0.4
        };
    });
    
    // Destroy previous chart if it exists
    if (chartInstance) {
        chartInstance.destroy();
    }
    
    chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: datasets
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        font: { size: 12, weight: 'bold' },
                        padding: 15,
                        usePointStyle: true,
                        pointStyle: 'circle'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: { size: 14, weight: 'bold' },
                    bodyFont: { size: 13 }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        font: { size: 12, weight: 'bold' }
                    },
                    grid: {
                        color: '#e0e0e0'
                    }
                },
                x: {
                    ticks: {
                        font: { size: 12, weight: 'bold' }
                    },
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
    
    // Update summary stats
    updateSummaryStats(data);
}

// Render table
function renderTable(data) {
    const tbody = document.getElementById('tableBody');
    tbody.innerHTML = '';
    
    // Sort according to current sort controls
    const sortedData = [...data].sort((a, b) => {
        const field = currentSortField || 'Year';
        const order = currentSortOrder || 'desc';
        let av = a[field];
        let bv = b[field];

        // ensure numeric comparison for Year and Count
        if (field === 'Year' || field === 'Count') {
            av = Number(av) || 0;
            bv = Number(bv) || 0;
            return order === 'asc' ? av - bv : bv - av;
        }

        // string comparison for Label
        av = String(av || '');
        bv = String(bv || '');
        const cmp = av.localeCompare(bv);
        return order === 'asc' ? cmp : -cmp;
    });
    
    sortedData.forEach(d => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${d.Year}</td>
            <td>${d.Label}</td>
            <td>${d.Count.toLocaleString()}</td>
        `;
        tbody.appendChild(row);
    });
}

// Update summary statistics
function updateSummaryStats(data) {
    const statsDiv = document.getElementById('summaryStats');
    statsDiv.innerHTML = '';
    
    if (data.length === 0) return;
    
    const counts = data.map(d => d.Count);
    const total = counts.reduce((a, b) => a + b, 0);
    const avg = Math.round(total / counts.length);
    const max = Math.max(...counts);
    const min = Math.min(...counts);
    const maxYear = data.find(d => d.Count === max).Year;
    const minYear = data.find(d => d.Count === min).Year;
    
    const stats = [
        { label: 'Total', value: total.toLocaleString() },
        { label: 'Average', value: avg.toLocaleString() },
        { label: 'Highest', value: `${max.toLocaleString()} (${maxYear})` },
        { label: 'Lowest', value: `${min.toLocaleString()} (${minYear})` }
    ];
    
    stats.forEach(stat => {
        const statDiv = document.createElement('div');
        statDiv.className = 'stat-item';
        statDiv.innerHTML = `
            <div class="label">${stat.label}</div>
            <div class="value">${stat.value}</div>
        `;
        statsDiv.appendChild(statDiv);
    });
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', initDashboard);
