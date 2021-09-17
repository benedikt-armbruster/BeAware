import serial
import json
import sqlite3 as sl
import time
import sys

table_name = 'DATA'
baud_rate = 115200
#serial_device = "/dev/cu.usbmodem5F4301D62"
serial_device = "/dev/ttyTHS1"
serial_channel = None

def connect_serial():
    while True:
        try:
            res = serial.Serial(serial_device, baud_rate)
            if res is not None:
                return res
            print("Retry to open serial after error in 60 seconds")
            time.sleep(60)
        except (serial.serialutil.SerialException, ValueError) as e:
            print("Retry to open serial after error in 60 seconds: " + str(e))
            time.sleep(60)

def main():
    global serial_channel
    print("Trying to connect to serial port")
    serial_channel = connect_serial()
    print("connected")
    con = sl.connect('sensor-values.db')
    with con:
        if con.execute(f"SELECT name FROM sqlite_master WHERE type='table' AND name='{table_name}';").fetchone() is None:
            con.execute(f"""
                CREATE TABLE {table_name} (
                    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                    data TEXT
                );
            """)
    value_count = 0    
    while True:
        try:
            line = serial_channel.readline()
            value_count += 1
            #print(line)
            print(f"\rValues read: {value_count}   ", end='')
            sys.stdout.flush()
        except (serial.serialutil.SerialException, ValueError) as e:
            print()
            print(str(e))
            try:
                serial_channel.close()
            except:
                pass
            print("Trying to reopen the port")
            serial_channel = connect_serial()
        #print(line)
        dataString = line.strip(b'\n\r')
        with con:
            try:
                dict = json.loads(dataString)
                con.execute(f'INSERT INTO {table_name} (data) values(?)', [dataString])
            except (json.decoder.JSONDecodeError, UnicodeDecodeError) as e:
                print(f"Could not parse line: {line}")
                print("Error occured: "+ str(e))


 
try:
    main()
except KeyboardInterrupt:
    pass
finally:
    try:
        serial_channel.close()
    except:
        pass