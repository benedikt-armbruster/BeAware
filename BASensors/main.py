from reader.sensor_reader import SensorReader
from reader.sensor_handler import SensorHandler
from hka.hka_server import HKServer
from webserver.webserver import WebServer
import logging
import sys

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="[%(module)s] %(message)s")
    if len(sys.argv) > 1:
        serial_port = sys.argv[1]
    else:
        serial_port = "/dev/ttyTHS1"

    WebServer.start()

    handler = SensorHandler(handler=HKServer().start())
    reader = SensorReader(serial_port)
    reader.add_callback(handler.handle)
    reader.start()
