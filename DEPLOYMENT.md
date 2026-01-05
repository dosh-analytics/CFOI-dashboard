# Deployment Guide

## Deploying the CFOI Dashboard

This guide explains how to deploy your dashboard to different platforms.

## Local Development (Recommended for Testing)

### Windows

1. **Open PowerShell or Command Prompt**
2. **Navigate to the dashboard:**
   ```
   cd "path\to\CFOI-dashboard"
   ```
3. **Start the server:**
   ```
   python server.py
   ```
4. **Access at:** `http://localhost:8000`

### Mac/Linux

1. **Open Terminal**
2. **Navigate to the dashboard:**
   ```
   cd path/to/CFOI-dashboard
   ```
3. **Start the server:**
   ```
   python3 server.py
   ```
4. **Access at:** `http://localhost:8000`

---

## Deploy to Static Web Server

### Option 1: Simple File Server (GitHub Pages, Netlify, Vercel)

**Best for:** Free, simple deployment

1. Create an account at [GitHub Pages](https://pages.github.com/), [Netlify](https://www.netlify.com/), or [Vercel](https://vercel.com/)

2. Upload your files:
   - `index.html`
   - `Raw_Fatality_Data.csv`
   - `www/` folder
   - `js/` folder

3. Files will be served automatically

### Option 2: Apache or Nginx

**Best for:** Enterprise environments

#### Apache

1. Copy files to your web root:
   ```
   sudo cp -r CFOI-dashboard /var/www/html/
   ```

2. Add to Apache config:
   ```apache
   <Directory /var/www/html/CFOI-dashboard>
       AllowOverride All
       Require all granted
       <FilesMatch "\.(csv|json)$">
           Header add "Access-Control-Allow-Origin" "*"
       </FilesMatch>
   </Directory>
   ```

3. Restart Apache:
   ```
   sudo systemctl restart apache2
   ```

#### Nginx

1. Copy files:
   ```
   sudo cp -r CFOI-dashboard /var/www/html/
   ```

2. Add to Nginx config:
   ```nginx
   server {
       listen 80;
       server_name yourdomain.com;
       root /var/www/html/CFOI-dashboard;
       index index.html;

       location / {
           try_files $uri $uri/ /index.html;
       }

       location ~* \.(csv|json)$ {
           add_header 'Access-Control-Allow-Origin' '*';
       }
   }
   ```

3. Test and reload:
   ```
   sudo nginx -t
   sudo systemctl reload nginx
   ```

### Option 3: Microsoft Azure Static Web Apps

**Best for:** Azure ecosystem

1. Create resource in Azure Portal
2. Connect your GitHub repository
3. Deploy files to `main` branch
4. Auto-deploys to `https://your-app.azurestaticapps.net`

### Option 4: AWS S3 + CloudFront

**Best for:** Scalability and CDN

1. **Create S3 bucket:**
   - Enable "Static website hosting"
   - Set index.html as index document

2. **Upload files:**
   ```bash
   aws s3 sync . s3://your-bucket-name
   ```

3. **Create CloudFront distribution**
   - Point to S3 bucket
   - Add CORS headers

4. **Access via CloudFront URL**

### Option 5: Docker Container

**Best for:** Consistency across environments**

Create `Dockerfile`:
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY . .
EXPOSE 8000
CMD ["python", "server.py"]
```

Build and run:
```bash
docker build -t cfoi-dashboard .
docker run -p 8000:8000 cfoi-dashboard
```

---

## Update Data on Deployed Site

### Method 1: Replace CSV File

1. Update `Raw_Fatality_Data.csv` locally
2. Verify it works: `python server.py`
3. Upload new CSV to server
4. Site updates automatically on next page refresh

### Method 2: Automated Updates (Optional)

Create a script to periodically update data:

```python
import schedule
import requests
import time

def update_data():
    # Fetch latest data from source
    url = "https://source.example.com/data.csv"
    response = requests.get(url)
    
    # Save to file
    with open('Raw_Fatality_Data.csv', 'w') as f:
        f.write(response.text)
    
    print("Data updated:", time.strftime('%Y-%m-%d %H:%M:%S'))

# Run every day at 2 AM
schedule.every().day.at("02:00").do(update_data)

while True:
    schedule.run_pending()
    time.sleep(60)
```

---

## Security Considerations

### HTTPS/SSL

For production, always use HTTPS:

1. **Get certificate** (Let's Encrypt is free)
2. **Configure server** to redirect HTTP to HTTPS
3. **Update all URLs** to use HTTPS

### CORS Headers

If CSV is on different domain, add CORS headers:

```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, OPTIONS
```

### Content Security Policy

Add to `index.html` in `<head>`:

```html
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self'; script-src 'self' https://cdn.jsdelivr.net https://cdn.plot.ly; style-src 'self' 'unsafe-inline'">
```

---

## Performance Optimization

### 1. Enable Gzip Compression

**Apache:**
```apache
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml
    AddOutputFilterByType DEFLATE text/css text/javascript
    AddOutputFilterByType DEFLATE application/javascript
</IfModule>
```

**Nginx:**
```nginx
gzip on;
gzip_types text/html text/css text/javascript application/javascript;
gzip_min_length 1000;
```

### 2. Browser Caching

**Apache:**
```apache
<FilesMatch "\.(html|js|css|csv|json)$">
    Header set Cache-Control "max-age=3600, public"
</FilesMatch>
```

### 3. Minify CSS/JS (Optional)

Use tools like:
- https://minifier.org/ (JavaScript)
- https://cssminifier.com/ (CSS)

---

## Monitoring & Logging

### Check Access Logs

**Apache:**
```bash
tail -f /var/log/apache2/access.log
```

**Nginx:**
```bash
tail -f /var/log/nginx/access.log
```

### Monitor Performance

Use tools like:
- Google Analytics
- New Relic
- Datadog
- CloudWatch (AWS)

---

## Troubleshooting Deployments

### "CSV Not Loading"
- Check CORS headers are configured
- Verify CSV file is in same directory
- Check browser console for errors

### "Dashboard Looks Broken"
- Clear browser cache
- Check CSS/JS files loaded (F12 developer tools)
- Verify all paths are relative, not absolute

### "Charts Not Displaying"
- Check Chart.js CDN is accessible
- Verify JavaScript errors in console
- Ensure data is loaded (check Network tab)

### "Slow Performance"
- Enable gzip compression
- Enable browser caching
- Use CDN for static files
- Optimize images
- Minify CSS/JS

---

## Rollback Procedure

If deployment fails:

1. **Keep backup of previous version**
2. **Revert files to previous commit** (if using Git)
3. **Restart server** or redeploy previous version
4. **Check logs** for error messages

---

## Support for Different Data Formats

If your data is in different format, modify `js/data-loader.js`:

### Excel (.xlsx)
```javascript
// Use SheetJS library
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.min.js"></script>
```

### JSON Format
```javascript
async function loadDataFromJSON() {
    const response = await fetch('data.json');
    return response.json();
}
```

### API Endpoint
```javascript
async function loadDataFromAPI() {
    const response = await fetch('https://api.example.com/fatality-data');
    return response.json();
}
```

---

## Recommended Deployment Platforms

| Platform | Cost | Ease | Scalability | Recommendation |
|----------|------|------|-------------|---|
| GitHub Pages | FREE | Easy | Medium | ✅ Best for public projects |
| Netlify | FREE | Easy | Medium | ✅ Great for simple sites |
| Vercel | FREE | Easy | Medium | ✅ Great for static sites |
| AWS S3 | $$ | Medium | High | For enterprise scale |
| Azure | $$ | Medium | High | For Microsoft ecosystem |
| DigitalOcean | $ | Medium | Medium | Good for control |
| Heroku | $$ | Easy | Low-Medium | Simpler than AWS |
| On-premises | Varies | Hard | Varies | Full control |

---

## Next Steps

1. **Choose deployment platform** based on your needs
2. **Test locally first** with `python server.py`
3. **Deploy files** to your chosen platform
4. **Test on production** URL
5. **Monitor performance** and user feedback
6. **Plan data updates** schedule

For detailed instructions on your chosen platform, visit their documentation.

---

**Questions?** See README.md or QUICKSTART.md
