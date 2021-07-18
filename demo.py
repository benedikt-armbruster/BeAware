from argparse import ArgumentParser
import json
import os, time

import cv2
import numpy as np

from modules.input_reader import VideoReader, ImageReader
from modules.draw import Plotter3d, draw_poses
from modules.parse_poses import parse_poses
from modules.data_saver import DataSaver


kpt_names = ['neck', 'nose', 'pelvis',
                 'l_sho', 'l_elb', 'l_wri', 'l_hip', 'l_knee', 'l_ank',
                 'r_sho', 'r_elb', 'r_wri', 'r_hip', 'r_knee', 'r_ank',
                 'r_eye', 'l_eye',
                 'r_ear', 'l_ear']

angle_between_limbs = [ [0, 3, 4], # left arm to neck
                        [0, 9, 10], # right arm to neck
                        [0, 1, 16], # left eye to neck
                        [0, 1, 15]] # right eye to neck

angle_between_limbs_names = ['l_arm_to_neck','r_arm_to_neck','l_eye_to_neck','r_eye_to_neck']

vertical_and_horizontal_angle_to_neck_keypoints = [
                            3, # left shoulde
                            9, # right shoulder
                            15, # right eye
                            16, # left eye
                            17, # right ear
                            18] # left ear

def rotate_poses(poses_3d, R, t):
    R_inv = np.linalg.inv(R)
    for pose_id in range(len(poses_3d)):
        pose_3d = poses_3d[pose_id].reshape((-1, 4)).transpose()
        pose_3d[0:3, :] = np.dot(R_inv, pose_3d[0:3, :] - t)
        poses_3d[pose_id] = pose_3d.transpose().reshape(-1)

    return poses_3d

def generate_features(poses_3d):
    #print(repr(poses_3d))
    reshaped_pose = poses_3d[0].reshape((-1, 4))
    positions = reshaped_pose.copy()
    neck = reshaped_pose[0]
    # all postions relative to neck
    positions[:, 0:3] = reshaped_pose[:,0:3] - neck[0:3]
    angles = np.zeros(len(angle_between_limbs), dtype=np.float32)
    for i, (start_idx, mid_idx, end_idx) in enumerate(angle_between_limbs):
        prob = min(reshaped_pose[start_idx,3],reshaped_pose[mid_idx,3],reshaped_pose[end_idx,3])
        if prob >= 0:
            start = reshaped_pose[start_idx,0:3]
            mid = reshaped_pose[mid_idx,0:3]
            end = reshaped_pose[end_idx,0:3]
            angles[i] = angle_between(start-mid, end-mid)
    for i, keypoint in enumerate(vertical_and_horizontal_angle_to_neck_keypoints):
        pass
    #print(repr((positions, angles)))
    return positions, angles
        
test = np.array([[  2.5629456 ,  -2.2665114 ,  84.14051   ,   0.77375156,
         -4.990353  , -20.207527  ,  72.258354  ,   0.89069915,
         -0.5897305 ,  44.814175  ,  83.4156    ,  -1.        ,
          2.9671154 ,  -0.99155605,  72.98802   ,   0.65190285,
          3.894011  ,  22.880924  ,  68.51622   ,   0.6213717 ,
         -7.9417224 ,  27.648167  ,  73.655     ,   0.3353548 ,
          8.579183  ,  45.518517  ,  79.48755   ,  -1.        ,
          8.346854  ,  79.764565  ,  79.51666   ,  -1.        ,
          8.9702    , 113.31031   ,  85.58753   ,  -1.        ,
          2.4198925 ,  -2.610878  ,  94.449     ,   0.79431367,
         -2.6483727 ,  21.659212  , 104.65866   ,   0.54932374,
        -19.414074  ,  39.69875   , 110.180115  ,   0.16838384,
         -8.443255  ,  44.533035  ,  87.14163   ,  -1.        ,
        -12.795666  ,  78.49885   ,  86.55894   ,  -1.        ,
        -10.600676  , 113.39931   ,  93.24348   ,  -1.        ,
         -2.9629588 , -19.448174  ,  71.60956   ,   0.95526385,
          4.745479  , -16.8222    ,  77.825195  ,   0.9503353 ,
         -6.44367   , -21.494232  ,  71.53551   ,   0.5246795 ,
         -5.942409  , -19.260656  ,  79.28537   ,   0.9065422 ]],
      dtype=np.float32)


# from https://stackoverflow.com/questions/2827393/angles-between-two-n-dimensional-vectors-in-python/13849249#13849249
def unit_vector(vector):
    """ Returns the unit vector of the vector.  """
    return vector / np.linalg.norm(vector)

def angle_between(v1, v2):
    """ Returns the angle in radians between vectors 'v1' and 'v2'::

            >>> angle_between((1, 0, 0), (0, 1, 0))
            1.5707963267948966
            >>> angle_between((1, 0, 0), (1, 0, 0))
            0.0
            >>> angle_between((1, 0, 0), (-1, 0, 0))
            3.141592653589793
    """
    v1_u = unit_vector(v1)
    v2_u = unit_vector(v2)
    return np.arccos(np.clip(np.dot(v1_u, v2_u), -1.0, 1.0))

# print(generate_features(test))

if __name__ == '__main__':
    parser = ArgumentParser(description='Lightweight 3D human pose estimation demo. '
                                        'Press esc to exit, "p" to (un)pause video or process next image.')
    parser.add_argument('-m', '--model',
                        help='Required. Path to checkpoint with a trained model '
                             '(or an .xml file in case of OpenVINO inference).',
                        type=str, required=True)
    parser.add_argument('--video', help='Optional. Path to video file or camera id.', type=str, default='')
    parser.add_argument('-d', '--device',
                        help='Optional. Specify the target device to infer on: CPU or GPU. '
                             'The demo will look for a suitable plugin for device specified '
                             '(by default, it is GPU).',
                        type=str, default='GPU')
    parser.add_argument('--use-openvino',
                        help='Optional. Run network with OpenVINO as inference engine. '
                             'CPU, GPU, FPGA, HDDL or MYRIAD devices are supported.',
                        action='store_true', default=False)
    parser.add_argument('--use-tensorrt',
                        help='Optional. Run network with TensorRT as inference engine. '
                             'Only Nvidia GPU devices are supported.',
                        action='store_true', default=False)
    parser.add_argument('--images', help='Optional. Path to input image(s).', nargs='+', default='')
    parser.add_argument('--height-size', help='Optional. Network input layer height size.', type=int, default=256)
    parser.add_argument('--extrinsics-path',
                        help='Optional. Path to file with camera extrinsics.',
                        type=str, default=None)
    parser.add_argument('--fx', type=np.float32, default=-1, help='Optional. Camera focal length.')
    parser.add_argument('--export-path',
                        help='Optional. Path to save the annotated images and pose data.',
                        type=str, default=None)
    parser.add_argument('--no-gui', action='store_true', default=False, help='Optional. Disable video preview')
    args = parser.parse_args()

    if args.video == '' and args.images == '':
        raise ValueError('Either --video or --image has to be provided')

    stride = 8
    if args.use_openvino:
        from modules.inference_engine_openvino import InferenceEngineOpenVINO
        net = InferenceEngineOpenVINO(args.model, args.device)
    elif args.use_tensorrt:
        from modules.inference_engine_tensorrt import InferenceEngineTensorRT
        net = InferenceEngineTensorRT(args.model, args.device)
    else:
        from modules.inference_engine_pytorch import InferenceEnginePyTorch
        net = InferenceEnginePyTorch(args.model, args.device)
    gui_enabled = not args.no_gui
    canvas_3d = np.zeros((720, 1280, 3), dtype=np.uint8)
    if gui_enabled:
        plotter = Plotter3d(canvas_3d.shape[:2])
        canvas_3d_window_name = 'Canvas 3D'
        cv2.namedWindow(canvas_3d_window_name)
        cv2.setMouseCallback(canvas_3d_window_name, Plotter3d.mouse_callback)
    
    if args.export_path is not None:
        save_data = DataSaver(args.export_path).save_to_disk
    else:
        def save_data(img, data):
            pass

    file_path = args.extrinsics_path
    if file_path is None:
        file_path = os.path.join('data', 'extrinsics.json')
    with open(file_path, 'r') as f:
        extrinsics = json.load(f)
    R = np.array(extrinsics['R'], dtype=np.float32)
    t = np.array(extrinsics['t'], dtype=np.float32)

    frame_provider = ImageReader(args.images)
    is_video = False
    if args.video != '':
        frame_provider = VideoReader(args.video)
        is_video = True
    base_height = args.height_size
    fx = args.fx

    delay = 1
    esc_code = 27
    p_code = 112
    space_code = 32
    mean_time = 0
    np.set_printoptions(formatter={'float': '{: 0.5f}'.format})
    for frame in frame_provider:
        current_time = cv2.getTickCount()
        if frame is None:
            break
        input_scale = base_height / frame.shape[0]
        scaled_img = cv2.resize(frame, dsize=None, fx=input_scale, fy=input_scale)
        scaled_img = scaled_img[:, 0:scaled_img.shape[1] - (scaled_img.shape[1] % stride)]  # better to pad, but cut out for demo
        if fx < 0:  # Focal length is unknown
            fx = np.float32(0.8 * frame.shape[1])
        t0 = time.time()
        inference_result = net.infer(scaled_img)
        print('Infer: {:1.3f}'.format(time.time()-t0))
        # print(type(inference_result))
        # for ar in inference_result:
        #     print(ar.shape)
        # break
        t0 = time.time()
        poses_3d, poses_2d = parse_poses(inference_result, input_scale, stride, fx, is_video)
        orig_poses_3d = poses_3d.copy()
        if len(poses_3d):
            normalized_pose = generate_features(poses_3d)
        else:
            normalized_pose = None
        print('Extract: {:1.3f}'.format(time.time()-t0))
        edges = []
        if len(poses_3d):
            for i, keypoint in enumerate(normalized_pose[0]):
                if keypoint[3] >= 0:
                    print(f'{kpt_names[i]}: {keypoint}')
            #print(poses_3d[0].reshape((-1, 4)))
            if gui_enabled:
                poses_3d = rotate_poses(poses_3d, R, t)
                poses_3d_copy = poses_3d.copy()
                x = poses_3d_copy[:, 0::4]
                y = poses_3d_copy[:, 1::4]
                z = poses_3d_copy[:, 2::4]
                poses_3d[:, 0::4], poses_3d[:, 1::4], poses_3d[:, 2::4] = -z, x, -y

                poses_3d = poses_3d.reshape(poses_3d.shape[0], 19, -1)[:, :, 0:3]
                edges = (Plotter3d.SKELETON_EDGES + 19 * np.arange(poses_3d.shape[0]).reshape((-1, 1, 1))).reshape((-1, 2))
        if gui_enabled:
            plotter.plot(canvas_3d, poses_3d, edges)
            cv2.imshow(canvas_3d_window_name, canvas_3d)

        draw_poses(frame, poses_2d)
        current_time = (cv2.getTickCount() - current_time) / cv2.getTickFrequency()
        if mean_time == 0:
            mean_time = current_time
        else:
            mean_time = mean_time * 0.95 + current_time * 0.05
        cv2.putText(frame, 'FPS: {}'.format(int(1 / mean_time * 10) / 10),
                    (40, 80), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255))
        cv2.putText(frame, 'Time: {:1.3f}'.format(current_time),
                    (40, 120), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255))
        cv2.putText(frame, f'Detected Persons: {len(poses_3d)}',
                    (40, 160), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255))
        if normalized_pose is not None:
            for i, keypoint in enumerate([0,1]): # enumerate([3,9]):
                cv2.putText(frame, f'{angle_between_limbs_names[keypoint]}: {normalized_pose[1][keypoint]}',
                            (40, 200 + i * 40), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255))
        if gui_enabled:
            cv2.imshow('ICV 3D Human Pose Estimation', frame)
        save_data(frame, orig_poses_3d.tolist())

        key = cv2.waitKey(delay)
        if key == esc_code:
            break
        if key == p_code:
            if delay == 1:
                delay = 0
            else:
                delay = 1
        if delay == 0 or not is_video:  # allow to rotate 3D canvas while on pause
            key = 0
            while (key != p_code
                   and key != esc_code
                   and key != space_code):
                plotter.plot(canvas_3d, poses_3d, edges)
                cv2.imshow(canvas_3d_window_name, canvas_3d)
                key = cv2.waitKey(33)
            if key == esc_code:
                break
            else:
                delay = 1

