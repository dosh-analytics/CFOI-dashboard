// Color palette matching the R dashboard
const colorPalette = {
    primary: '#25408F',
    secondary: '#B94700',
    accent: '#FFD41C',
    light: '#9098CF',
    gender: ['#FFD41C', '#6ECAC8'],
    race: ['#9D9FA2', '#9098CF', '#F2EEDD', '#00A8E0', '#6ECAC8', '#94C83D', '#FFD41C', '#FF69B4'],
    multiColor: ['#25408F', '#503871', '#673461', '#842f4d', '#af272f', '#c96029', '#e29623', '#ffd41c']
};

let globalData = [];
let currentTab = 'totals';
let chartInstance = null;

// Initialize dashboard
async function initDashboard() {
    // Load data
    globalData = await dataLoader.loadDataFromCSV();
    
    // Setup event listeners
    setupTabListeners();
    setupResetButton();
    
    // Render initial view
    renderView('totals');
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
            title = 'California Fatal Occupational Injuries by Race/Ethnicity (2013-2023)';
            colors = colorPalette.multiColor;
            renderMultiLineChart(data, title, colors);
            break;
            
        case 'age':
            data = dataLoader.filterData(globalData, { class: 'Age' });
            title = 'California Fatal Occupational Injuries by Age Group (2009-2023)';
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
                    max: 500,
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
    const labels = data.map(d => d.Year);
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
    
    // Sort data by year descending, then by label
    const sortedData = [...data].sort((a, b) => {
        if (a.Year !== b.Year) return b.Year - a.Year;
        return a.Label.localeCompare(b.Label);
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
