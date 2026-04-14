// Parse the CSV data embedded in the page or loaded from file
const fatality_data = [
    { class: 'Totals', Label: 'Totals', Count: 394, Year: 1999 },
    { class: 'Totals', Label: 'Totals', Count: 369, Year: 2000 },
    { class: 'Totals', Label: 'Totals', Count: 388, Year: 2001 },
    { class: 'Totals', Label: 'Totals', Count: 396, Year: 2002 },
    { class: 'Totals', Label: 'Totals', Count: 414, Year: 2003 },
    { class: 'Totals', Label: 'Totals', Count: 414, Year: 2004 },
    { class: 'Totals', Label: 'Totals', Count: 412, Year: 2005 },
    { class: 'Totals', Label: 'Totals', Count: 440, Year: 2006 },
    { class: 'Totals', Label: 'Totals', Count: 448, Year: 2007 },
    { class: 'Totals', Label: 'Totals', Count: 431, Year: 2008 },
    { class: 'Totals', Label: 'Totals', Count: 433, Year: 2009 },
    { class: 'Totals', Label: 'Totals', Count: 436, Year: 2010 },
    { class: 'Totals', Label: 'Totals', Count: 445, Year: 2011 },
    { class: 'Totals', Label: 'Totals', Count: 452, Year: 2012 },
    { class: 'Totals', Label: 'Totals', Count: 431, Year: 2013 },
    { class: 'Totals', Label: 'Totals', Count: 437, Year: 2014 },
    { class: 'Totals', Label: 'Totals', Count: 437, Year: 2015 },
    { class: 'Totals', Label: 'Totals', Count: 460, Year: 2016 },
    { class: 'Totals', Label: 'Totals', Count: 468, Year: 2017 },
    { class: 'Totals', Label: 'Totals', Count: 447, Year: 2018 },
    { class: 'Totals', Label: 'Totals', Count: 434, Year: 2019 },
    { class: 'Totals', Label: 'Totals', Count: 430, Year: 2020 },
    { class: 'Totals', Label: 'Totals', Count: 433, Year: 2021 },
    { class: 'Totals', Label: 'Totals', Count: 437, Year: 2022 },
    { class: 'Totals', Label: 'Totals', Count: 439, Year: 2023 },
    { class: 'Totals', Label: 'Totals', Count: 419, Year: 2024 }
];

// Function to parse CSV string
function parseCSV(csv) {
    const lines = csv.trim().split('\n');
    const data = [];
    
    for (let i = 1; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) continue;
        
        // Simple CSV parsing - handles basic cases
        const parts = [];
        let current = '';
        let inQuotes = false;
        
        for (let j = 0; j < line.length; j++) {
            const char = line[j];
            if (char === '"') {
                inQuotes = !inQuotes;
            } else if (char === ',' && !inQuotes) {
                parts.push(current.trim().replace(/^"|"$/g, ''));
                current = '';
            } else {
                current += char;
            }
        }
        parts.push(current.trim().replace(/^"|"$/g, ''));
        
        if (parts.length >= 4) {
            data.push({
                class: parts[0],
                Label: parts[1],
                Count: parseInt(parts[2]) || 0,
                Year: parseInt(parts[3]) || 0
            });
        }
    }
    
    return data;
}

// Function to load data from CSV file
async function loadDataFromCSV() {
    try {
        // Construct the correct path for both local and GitHub Pages
        const baseUrl = window.location.pathname.includes('/CFOI-dashboard/') 
            ? '/CFOI-dashboard/' 
            : './';
        const csvPath = baseUrl + 'Raw_Fatality_Data.csv';
        
        console.log('Loading CSV from:', csvPath);
        const response = await fetch(csvPath);
        if (!response.ok) throw new Error('File not found: ' + csvPath);
        const csv = await response.text();
        const data = parseCSV(csv);
        return data.length > 0 ? data : fatality_data;
    } catch (error) {
        console.log('CSV file not found, using embedded data:', error);
        return fatality_data;
    }
}

// Function to get unique values from data
function getUniqueValues(data, field) {
    return [...new Set(data.map(d => d[field]))].sort();
}

// Function to filter data
function filterData(data, filters = {}) {
    return data.filter(d => {
        if (filters.class && d.class !== filters.class) return false;
        if (filters.year && d.Year !== filters.year) return false;
        if (filters.label && d.Label !== filters.label) return false;
        return true;
    });
}

// Function to group data by category
function groupByLabel(data) {
    const grouped = {};
    data.forEach(d => {
        if (!grouped[d.Label]) grouped[d.Label] = [];
        grouped[d.Label].push(d);
    });
    return grouped;
}

// Function to group data by year
function groupByYear(data) {
    const grouped = {};
    data.forEach(d => {
        if (!grouped[d.Year]) grouped[d.Year] = [];
        grouped[d.Year].push(d);
    });
    return grouped;
}

// Export for use in other scripts
window.dataLoader = {
    loadDataFromCSV,
    getUniqueValues,
    filterData,
    groupByLabel,
    groupByYear,
    fatality_data
};
