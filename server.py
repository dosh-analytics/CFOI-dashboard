#!/usr/bin/env python3
"""
Simple HTTP Server for CFOI Dashboard
Serves the HTML dashboard on localhost:8000
"""

import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler
import webbrowser

class MyHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        # Add CORS headers for local development
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        return super().end_headers()

def run_server(port=8000):
    """Start the HTTP server"""
    # Change to the dashboard directory
    dashboard_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(dashboard_dir)
    
    server_address = ('', port)
    httpd = HTTPServer(server_address, MyHTTPRequestHandler)
    
    print(f"Server starting on http://localhost:{port}")
    print(f"Press Ctrl+C to stop the server")
    print(f"Serving files from: {dashboard_dir}")
    
    try:
        # Open browser if possible
        try:
            webbrowser.open(f'http://localhost:{port}')
        except:
            pass
        
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped")
        sys.exit(0)

if __name__ == '__main__':
    port = 8000
    if len(sys.argv) > 1:
        try:
            port = int(sys.argv[1])
        except ValueError:
            print(f"Invalid port number: {sys.argv[1]}")
            sys.exit(1)
    
    run_server(port)
