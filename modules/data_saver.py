import json
import time
import cv2
from pathlib import Path


class DataSaver:
    counter_file_name = 'counter.json'

    def __init__(self, file_path):
        self.path = Path(file_path)
        if not self.path.is_dir():
            raise IOError('Path is not a directory')
        self._read_counter_from_disk()

    def save_to_disk(self, img, poses):
        self.counter += 1
        self._write_counter_to_disk()
        img_filename, poses_filename = self._get_file_names()
        with open(poses_filename, 'w') as outfile:
            json.dump(poses, outfile)
        cv2.imwrite(img_filename, img)

    def _read_counter_from_disk(self):
        counter_file_path = self.path.joinpath(self.counter_file_name)
        if not counter_file_path.is_file():
            self.counter = 0
            self._write_counter_to_disk()
            return
        with counter_file_path.open('r') as json_file:
            self.counter = json.load(json_file)['counter']

    def _write_counter_to_disk(self):
        counter_file_path = self.path.joinpath(self.counter_file_name)
        with counter_file_path.open('w') as outfile:
            json.dump({'counter': self.counter}, outfile)

    def _get_file_names(self):
        base = str(self.path.joinpath("{:06d}_{}".format(self.counter, time.strftime("%Y%m%d-%H%M%S"))))
        return base + ".png", base + ".json"
