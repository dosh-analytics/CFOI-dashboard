# California Workplace Fatality Dashboard

A modern, interactive HTML5 dashboard displaying California Fatal Occupational Injuries (CFOI) data from 1999-2023.

## Overview

This dashboard provides comprehensive visualization of workplace fatality data in California, broken down by:
- Total fatalities over time
- Gender
- Race/Ethnicity
- Age groups
- Employment status
- Fatal event types
- Industry
- Occupation

## Features

- **Interactive Charts**: Line charts with hover tooltips and legend controls
- **Data Tables**: Sortable tables with all underlying data
- **Summary Statistics**: Key metrics including totals, averages, highs, and lows
- **Key Performance Indicators (KPIs)**: Quick view of 2023 totals and rates
- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **No Backend Required**: Pure HTML/CSS/JavaScript - works offline

## Files Structure

```
CFOI-dashboard/
├── index.html                    # Main dashboard HTML
├── server.py                     # Local development server
├── Raw_Fatality_Data.csv         # Source data file
├── www/
│   └── styles.css                # Custom styles
└── js/
    ├── data-loader.js            # Data loading and parsing
    └── dashboard.js              # Dashboard functionality
```

## How to Use

### Option 1: Using Python Server (Recommended)

1. Open PowerShell or Command Prompt
2. Navigate to the dashboard directory:
   ```
   cd "c:\Users\Ryan Furtkamp\OneDrive - California Department of Industrial Relations\Documents\GitHub\CFOI-dashboard"
   ```
3. Run the server:
   ```
   python server.py
   ```
4. Open your browser to `http://localhost:8000`

### Option 2: Direct File Access

Simply open `index.html` in your web browser. Note: CSV data loading may not work due to browser security restrictions. The dashboard will use embedded fallback data.

### Option 3: Deploy to Web Server

1. Upload all files to your web server
2. Access via HTTP URL

## Data Format

The dashboard reads data from `Raw_Fatality_Data.csv` with the following format:

```
class,Label,Count,Year
Totals,Totals,394,1999
Gender,Women,42,2009
Race,Hispanic,150,2023
...
```

## Customization

### Colors
Edit the `colorPalette` object in `js/dashboard.js` to change the color scheme.

### Data Updates
Replace `Raw_Fatality_Data.csv` with updated data. The dashboard will automatically reload it.

### Styling
Modify `www/styles.css` to customize fonts, colors, and layout.

## Browser Compatibility

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Mobile browsers (iOS Safari, Chrome Mobile)

## Dependencies

The dashboard uses the following external libraries (loaded via CDN):
- **Chart.js** (v4.4.0) - Chart rendering
- **Plotly.js** - Advanced charting (loaded but not currently used)

All other functionality is vanilla JavaScript with no dependencies.

## Data Source

California Fatal Occupational Injuries (CFOI) Program
Division of Occupational Safety and Health (DOSH)
California Department of Industrial Relations (DIR)

## Version History

### v2.0 (2024)
- Converted from R Shiny to pure HTML5 dashboard
- Added interactive tab navigation
- Implemented Chart.js for visualizations
- Responsive design improvements
- No backend server required

### v1.0
- Original R Shiny implementation

## Notes

- Data is from 1999-2023
- The dashboard falls back to embedded data if CSV cannot be loaded
- Summary statistics update based on selected data view
- All charts are fully responsive and mobile-friendly

## Questions or Issues?

Contact the California Department of Industrial Relations, Division of Occupational Safety and Health (DOSH)

