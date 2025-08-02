import socket
import cv2
import mediapipe as mp


HOST = '127.0.0.1'
PORT = 8000

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh()

cap = cv2.VideoCapture(0)

def get_head_direction(landmarks):
    left_eye = landmarks[33]
    right_eye = landmarks[263]
    dx = right_eye.x - left_eye.x
    eye_distance = abs(dx)

    # Midpoint between eyes
    mid_x = (left_eye.x + right_eye.x) / 2
    nose_x = landmarks[1].x  # Nose tip

    # Offset from center (normalized)
    offset = nose_x - mid_x
    relative_turn = offset / eye_distance

    # Threshold for movement detection
    if abs(relative_turn) > 0.25:
        return "MOVE"
    else:
        return "STILL"

while True:
    ret, frame = cap.read()
    if not ret:
        continue
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = face_mesh.process(frame_rgb)
    
    if results.multi_face_landmarks:
        landmarks = results.multi_face_landmarks[0].landmark
        direction = get_head_direction(landmarks)
        sock.sendto(direction.encode(), (HOST, PORT))

    cv2.imshow("Head Tracking", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
sock.close()
cv2.destroyAllWindows()