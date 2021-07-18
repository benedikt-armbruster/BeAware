import cv2

class ImageReader:
    def __init__(self, file_names):
        self.file_names = file_names
        self.max_idx = len(file_names)

    def __iter__(self):
        self.idx = 0
        return self

    def __next__(self):
        if self.idx == self.max_idx:
            raise StopIteration
        img = cv2.imread(self.file_names[self.idx], cv2.IMREAD_COLOR)
        if img.size == 0:
            raise IOError('Image {} cannot be read'.format(self.file_names[self.idx]))
        self.idx = self.idx + 1
        return img


class VideoReader:
    def __init__(self, file_name):
        if len(file_name) == 2 and file_name[0] == 'c':
            self.is_csi = True
            self.file_name = int(file_name[1])
        else:
            self.is_csi = False
            self.file_name = file_name
            try:  # OpenCV needs int to read from webcam
                self.file_name = int(file_name)
            except ValueError:
                pass

    def __iter__(self):
        if self.is_csi:
            self.cap = cv2.VideoCapture(self._gst_str_csi(), cv2.CAP_GSTREAMER)
        else:
            self.cap = cv2.VideoCapture(self.file_name)
            self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1920)
            self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 1080)
        if not self.cap.isOpened():
            raise IOError('Video {} cannot be opened'.format(self.file_name))
        return self

    def __next__(self):
        was_read, img = self.cap.read()
        if not was_read:
            raise StopIteration
        return img

    def _gst_str_csi(self, capture_width=3264, capture_height=2464, capture_fps=21, width=1920, height=1080 ):
        return 'nvarguscamerasrc sensor-id=%d ! video/x-raw(memory:NVMM), width=%d, height=%d, format=(string)NV12, framerate=(fraction)%d/1 ! nvvidconv ! video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx ! videoconvert ! appsink max-buffers=1 drop=True ' % (
                self.file_name, capture_width, capture_height, capture_fps, width, height)