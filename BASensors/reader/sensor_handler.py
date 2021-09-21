import sqlite3 as sl


class SensorHandler:
    ignored_fields = ['sensor', 'success']

    def __init__(self, handler=None):
        if handler is None:
            handler = {}
        self.handler = handler

    def handle(self, timestamp, base_reading):
        for base_sensor, values in base_reading.items():
            if values is None or not values['success']:
                continue
            for sensor_name, value in values.items():
                if sensor_name in self.ignored_fields:
                    continue
                SensorValueDatabase.save_value(base_sensor, base_sensor + '_' + sensor_name, timestamp, value)
                if base_sensor in self.handler and sensor_name in self.handler[base_sensor]:
                    handlers = self.handler[base_sensor][sensor_name]
                    if isinstance(handlers, list):
                        for handler in handlers:
                            handler(value)
                    else:
                        handlers(value)
        SensorValueDatabase.update_json()


class SensorValueDatabase:
    table_name = 'sensor_values'
    con = None
    table_checked = False
    json_last_id = -1
    json_entries = {}

    @staticmethod
    def _check_table():
        # not thread safe!
        if SensorValueDatabase.table_checked:
            return
        SensorValueDatabase.con = sl.connect('sensor-values.db')
        with SensorValueDatabase.con:
            if SensorValueDatabase.con.execute(
                    f"SELECT name FROM sqlite_master WHERE type='table' AND name='{SensorValueDatabase.table_name}';").fetchone() is None:
                SensorValueDatabase.con.execute(f"""
                        CREATE TABLE {SensorValueDatabase.table_name} (
                            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                            timestamp INTEGER,
                            base_sensor TEXT,
                            sensor_name TEXT,
                            value REAL
                        );
                    """)
        SensorValueDatabase.table_checked = True

    @staticmethod
    def save_value(base_sensor, sensor_name, timestamp, value):
        SensorValueDatabase._check_table()
        with SensorValueDatabase.con:
            SensorValueDatabase.con.execute(
                f'INSERT INTO {SensorValueDatabase.table_name} (timestamp, base_sensor, sensor_name, value) values(?,?,?,?)',
                [timestamp, base_sensor, sensor_name, value])

    @staticmethod
    def update_json():
        SensorValueDatabase._check_table()
        with SensorValueDatabase.con:
            rows = SensorValueDatabase.con.execute(f'SELECT id, timestamp, base_sensor, sensor_name, value FROM {SensorValueDatabase.table_name} WHERE id > {SensorValueDatabase.json_last_id}').fetchall()
            result_dict = SensorValueDatabase.json_entries
            for row in rows:
                SensorValueDatabase.json_last_id = max(SensorValueDatabase.json_last_id, row[0])
                entry = {'id': row[0],
                         'ts':  row[1],
                         'bs': row[2],
                         'sn': row[3],
                         'v': row[4]}
                if row[2] not in result_dict:
                    result_dict[row[2]] = {}
                if row[3] not in result_dict[row[2]]:
                    result_dict[row[2]][row[3]] = []
                result_dict[row[2]][row[3]].append(entry)
            SensorValueDatabase.json_entries = result_dict

    @staticmethod
    def get_json_values():
        return SensorValueDatabase.json_entries