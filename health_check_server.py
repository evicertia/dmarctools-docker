from http.server import SimpleHTTPRequestHandler, HTTPServer
import subprocess

class HealthCheckHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            # Check if the main script is running
            result = subprocess.run(["pgrep", "-f", "parsedmarc"], stdout=subprocess.PIPE)

            if result.returncode == 0:
                # If the script is running, return a 200 response
                self.send_response(200)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(b"Healthy")
            else:
                # If the script is not running, return a 503 response
                self.send_response(503)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(b"Unhealthy")
        else:
            self.send_error(404, "File not found")

def run(server_class=HTTPServer, handler_class=HealthCheckHandler):
    server_address = ('', 8080)
    httpd = server_class(server_address, handler_class)
    print("Starting health check server...")
    httpd.serve_forever()

if __name__ == '__main__':
    run()
