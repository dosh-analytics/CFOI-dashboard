# Quick Start Guide - CFOI Dashboard

## Getting Started in 30 Seconds

### Windows Users:

1. **Open PowerShell** (press `Win + X`, then select "Windows PowerShell" or "Terminal")

2. **Navigate to the dashboard folder:**
   ```powershell
   cd "c:\Users\Ryan Furtkamp\OneDrive - California Department of Industrial Relations\Documents\GitHub\CFOI-dashboard"
   ```

3. **Start the server:**
   ```powershell
   python server.py
   ```

4. **Open in browser:**
   - Your browser should automatically open to `http://localhost:8000`
   - If not, manually go to that URL

5. **View the dashboard and interact with tabs to explore data**

6. **Stop the server:** Press `Ctrl + C` in PowerShell

---

## Dashboard Navigation

### Tabs Available:
- **Total Fatalities** - Overall workplace fatalities over time
- **Gender** - Breakdown by male/female
- **Race/Ethnicity** - Fatalities by race/ethnicity
- **Age** - Fatalities by age group
- **Employment Status** - Employed vs. self-employed
- **Fatal Event** - By type of accident (falls, electrocution, etc.)
- **Industry** - By industry sector
- **Occupation** - By occupation type

### Features:
- **Interactive Chart**: Hover to see exact values
- **Data Table**: See all raw numbers below the chart
- **Summary Stats**: Total, average, highest, and lowest values
- **Reset View**: Clear selections and return to default view

---

## File Locations

- **Dashboard**: `index.html`
- **Data**: `Raw_Fatality_Data.csv`
- **Styles**: `www/styles.css`
- **Scripts**: `js/data-loader.js` and `js/dashboard.js`
- **Server**: `server.py`

---

## Troubleshooting

### Server won't start?
- Make sure you're in the correct directory
- Check that Python is installed: `python --version`
- Try port 8080 instead: `python server.py 8080`

### Charts not loading?
- Refresh the page (Ctrl + F5)
- Check browser console for errors (F12)
- Make sure you're using an up-to-date browser

### Data not showing?
- Verify `Raw_Fatality_Data.csv` is in the same folder as `index.html`
- If CSV is missing, the dashboard will use built-in sample data

---

## Sharing the Dashboard

To share with others:
1. Keep the server running
2. Share the URL: `http://localhost:8000`
3. Others must be on the same network

For public deployment, upload all files to a web server and access via HTTPS.

---

## Updates

To update the data:
1. Replace `Raw_Fatality_Data.csv` with new data
2. Refresh the browser page
3. No code changes needed!

---

**Questions?** Check README.md for more details.
