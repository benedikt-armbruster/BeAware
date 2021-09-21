import serial
import json
import sqlite3 as sl
import time
import sys
import threading
import logging
from datetime import datetime


class SensorReader:

    def __init__(self, serial_device = "/dev/ttyTHS1"):
        self.table_name = 'DATA'
        self.baud_rate = 115200
        # serial_device = "/dev/cu.usbmodem5F4301D62"
        self.serial_device = serial_device
        self.serial_channel = None
        self.listeners = []
        self.thread = None

    def add_callback(self, callback):
        self.listeners.append(callback)

    def connect_serial(self):
        while True:
            try:
                res = serial.Serial(self.serial_device, self.baud_rate)
                if res is not None:
                    return res
                print("Retry to open serial after error in 60 seconds")
                time.sleep(60)
            except (serial.serialutil.SerialException, ValueError) as e:
                print("Retry to open serial after error in 60 seconds: " + str(e))
                time.sleep(60)

    def start(self):
        if self.thread is not None:
            raise RuntimeError("Reader already started")
        self.thread = threading.Thread(target=self._run())
        self.thread.start()

    def _run(self):
        try:
            self._read()
        except KeyboardInterrupt:
            pass
        finally:
            # noinspection PyBroadException
            try:
                self.serial_channel.close()
            except:
                pass

    def _read(self):
        print("Trying to connect to serial port")
        self.serial_channel = self.connect_serial()
        print("connected")
        con = sl.connect('sensor-values-raw.db')
        with con:
            if con.execute(
                    f"SELECT name FROM sqlite_master WHERE type='table' AND name='{self.table_name}';").fetchone() is None:
                con.execute(f"""
                    CREATE TABLE {self.table_name} (
                        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                        data TEXT
                    );
                """)
        value_count = 0
        while True:
            try:
                line = self.serial_channel.readline()
                value_count += 1
                # print(line)
                print(f"\rValues read: {value_count} {str(datetime.now())}        ", end='')
                sys.stdout.flush()
            except (serial.serialutil.SerialException, ValueError) as e:
                print()
                print(str(e))
                try:
                    self.serial_channel.close()
                except:
                    pass
                print("Trying to reopen the port")
                self.serial_channel = self.connect_serial()
            # print(line)
            dataString = line.strip(b'\n\r')
            with con:
                try:
                    dict = json.loads(dataString)
                    con.execute(f'INSERT INTO {self.table_name} (data) values(?)', [dataString])
                    timestamp = datetime.now().timestamp()
                    self._notify_listener(timestamp, dict)
                except (json.decoder.JSONDecodeError, UnicodeDecodeError) as e:
                    logging.info(f"Could not parse line: {line}")
                    print("Error occured: " + str(e))

    def _notify_listener(self, timestamp, value):
        for listener in self.listeners:
            # noinspection PyBroadException
            try:
                listener(timestamp, value)
            except:
                logging.exception('Exception while calling listener')


if __name__ == "__main__":
    reader = SensorReader()
    reader._run()