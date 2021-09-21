import http.server
import socketserver
import threading
import json
from reader.sensor_handler import SensorValueDatabase

PORT = 8081


class RequestHandler(http.server.SimpleHTTPRequestHandler):
    allowed_files = ['/sensor-values.db']
    sensor_db = SensorValueDatabase()

    def do_GET(self):
        if self.path == '/allSensorValues':
            return self.return_json(SensorValueDatabase.get_json_values())
        if self.check_file_allowed():
            return http.server.SimpleHTTPRequestHandler.do_GET(self)

    def do_HEAD(self):
        if self.path == '/allSensorValues':
            return self._set_headers()
        if self.check_file_allowed():
            return http.server.SimpleHTTPRequestHandler.do_HEAD(self)

    def check_file_allowed(self):
        if self.path not in RequestHandler.allowed_files:
            self.send_error(404)
            return False
        return True

    # allow cors
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        http.server.SimpleHTTPRequestHandler.end_headers(self)


    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def return_json(self, json_dict):
        self._set_headers()
        response = json.dumps(json_dict)
        response = bytes(response, 'utf-8')
        try:
            self.wfile.write(response)
        except BrokenPipeError:
            print("Broken pipe while serving json request")

class WebServer:
    @staticmethod
    def start():
        threading.Thread(target=WebServer._run, daemon=True).start()

    @staticmethod
    def _run():
        with socketserver.TCPServer(("", PORT), RequestHandler) as httpd:
            print("Server started at localhost:" + str(PORT))
            httpd.serve_forever()