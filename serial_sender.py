import numpy as np
import serial
import socket
import keyboard
import dubins_path_planner

def walk_forward():
    return "kwkF"

def walk_forward_right():
    return "kwkR"

def walk_forward_left():
    return "kwkL"

def stop_dog():
    return "kbalance"

def translate_command(str):
    if str == 'R':
        return walk_forward_right()
    elif str == 'L':
        return walk_forward_left()
    elif str == 'S':
        return walk_forward()
    elif str == "STOP":
        return stop_dog()

def get_direction(cur_x, cur_y, d_list):
    if (abs(cur_x - d_list[0]) < 0.2 and abs(cur_y - d_list[1]) < 0.2 ): # [m]
        return translate_command(d_list[2])



def main():
    # change the port as necessary by your OS
    ser = serial.Serial('/dev/cu.BittleSPP-3531F3 Serial Port', 115200)

    # for running server
    HOST = ''
    PORT = 12345              # Arbitrary non-privileged port
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((HOST, PORT))
    s.listen(1)
    conn, addr = s.accept()
    print('Connected by', addr)

    # for dubins path
    start_x = 4.5  # [m]
    start_y = 0.0  # [m]
    start_yaw = np.deg2rad(270)  # [rad]

    end_x = 0.0  # [m]
    end_y = -2.5  # [m]
    end_yaw = np.deg2rad(180)  # [rad]

    curvature = 1.0
    step_size = 0.1
    path_x, path_y, path_yaw, mode, lengths = dubins_path_planner.plan_dubins_path(
        start_x, start_y, start_yaw, end_x, end_y, end_yaw, curvature, step_size)

    # to get the directions
    direction_list = []
    for i in range(len(path_yaw)-1):
            if path_yaw[i] != path_yaw[i+1] and (len(direction_list) == 0):
                direction_list.append([mode[0], path_x[i], path_y[i]])
            elif path_yaw[i] == path_yaw[i+1] and len(direction_list) == 1:
                direction_list.append([mode[1], path_x[i], path_y[i]])
            elif path_yaw[i] != path_yaw[i+1] and len(direction_list) == 2:
                direction_list.append([mode[2], path_x[i], path_y[i]])
    direction_list.append(["STOP", end_x, end_y])
    print(direction_list)

    i = 0 # this variable will count the iterations

    # infinite server loop
    while True:
        data = conn.recv(1024)
        if not data:
            break
        # do stuff
        split_string = data.decode().split(",")
        cur_x = int(split_string[0])
        cur_y = int(split_string[1])
        print(f"x = {cur_x} , y = {cur_y}")

        new_direction = ""
        if i < 4:
            new_direction = get_direction(cur_x, cur_y, direction_list[i])
            if new_direction != "":
                i += 1

        # for keyboard commands
        if keyboard.is_pressed('w'):
            new_direction = walk_forward()
        elif keyboard.is_pressed('a'):
            new_direction = walk_forward_left()
        elif keyboard.is_pressed('s'):
            new_direction = stop_dog()
        elif keyboard.is_pressed('d'):
            new_direction = walk_forward_right()

        if cur_direction != new_direction:
            cur_direction = new_direction
            ser.write(new_direction.encode()) # Send the data to the serial port for dog to change directions

    conn.close()


if __name__ == '__main__':
    main()