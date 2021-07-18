import threading, queue, pickle
import cv2
import socket


class DataSender:

    def __init__(self, host = '0.0.0.0', port = 9090):
        self._queue = queue.Queue(2)
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._socket.bind((host, port))
        self._socket.listen(1)
        self._run = True
        self._thread = threading.Thread(target=self._wait_and_handle_connection)
        self._thread.daemon = True
        self._thread.start()

    def _wait_and_handle_connection(self):
        print('TCP server started')
        while self._run:
            client_socket, addr = self._socket.accept()
            print(f'TCP client connected: {str(addr)}')
            self._transmit(client_socket)
            print('TCP client disconnected')
            try:
                client_socket.close()
            except:
                pass
        self._socket.close()

    def _transmit(self, client_socket):
        while self._run:
            try:
                img, poses_3d, poses_2d = self._queue.get(timeout=10)
                data = self._serialize(img, poses_3d, poses_2d)
                # client_socket.sendall(len(data).to_bytes(8, byteorder='big'))
                err = client_socket.sendall(data)
                if err is not None:
                    return
            except queue.Empty:
                pass
            except BrokenPipeError:
                return

    def send(self, img, poses_3d, poses_2d):
        if not self._queue.full():
            try:
                self._queue.put_nowait((img, poses_3d, poses_2d))
            except queue.Full:
                pass

    @staticmethod
    def _serialize(img, poses_3d, poses_2d):
        data = {
            'img': cv2.imencode('.png', img)[1],
            'poses_3d': poses_3d,
            'poses_2d': poses_2d
        }
        return pickle.dumps(data)


class DataReceiver:

    def __init__(self, host, port):
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._socket.connect((host, port))
        self._stream = self._socket.makefile('rb')

    def receive(self):
        while True:
            try:
                yield self._unpack(pickle.load(self._stream))
            except EOFError:
                break

    @staticmethod
    def _unpack(obj):
        return cv2.imdecode(obj['img'], cv2.IMREAD_COLOR), obj['poses_3d'], obj['poses_2d']


if __name__ == '__main__':
    rec = DataReceiver('192.168.178.47', 9090)
    for img, poses_3d, poses_2d in rec.receive():
        print(poses_3d)
        cv2.imshow('BeAware Camera Feed', img)
        cv2.waitKey(1)
