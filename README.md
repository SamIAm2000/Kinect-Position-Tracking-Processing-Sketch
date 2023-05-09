# Kinect Position Tracking Processing Sketch
Position Tracking for bodies using 2 Kinects rigged to the ceiling (configured to the Barnard College Movement Lab set up)

## Current Updates as of 5/9/2023
TLDR: Infrared works better than depth sensing, pathfinding in Python using infrared location still needs to be tested.

The [Kinect_depth_sensors](https://github.com/SamIAm2000/Kinect-Position-Tracking-Processing-Sketch/tree/main/Kinect_depth_sensors) folder contains code that uses the depth sensors from the Kinects installed in the Movement Lab's ceiling to track the robot. The code works but the tracking is limited to a very small area due to the height of the robot being very small and the Kinects being prone to tilting.

The [Kinect_infrared_sensors](https://github.com/SamIAm2000/Kinect-Position-Tracking-Processing-Sketch/tree/main/Kinect_infrared_sensors) folder contains code that uses the infrared camera of the Kinects to sense the robot. To our knowledge, this works the best so far, especially after sticking reflective tape on the robot. It communicates to the robot using serial and Bluetooth within Processing.

The [infrared_dubins_path](https://github.com/SamIAm2000/Kinect-Position-Tracking-Processing-Sketch/tree/main/infrared_dubins_path) folder contains code that builds off of the [Kinect_infrared_sensors](https://github.com/SamIAm2000/Kinect-Position-Tracking-Processing-Sketch/tree/main/Kinect_infrared_sensors) folder and connects to a server that is served from the [serial_sender.py](https://github.com/SamIAm2000/Kinect-Position-Tracking-Processing-Sketch/blob/main/serial_sender.py) file. It still uses infrared to detect the robot and sends over the robot's location to the python file. The python file communicates with the dog using serial. 

For the file [serial_sender.py](https://github.com/SamIAm2000/Kinect-Position-Tracking-Processing-Sketch/blob/main/serial_sender.py), the server part of the file works and Processing is able to communicate with the python pathfinding file, however, the serial communication to the dog has not been tested yet.

The [testing and support](https://github.com/SamIAm2000/Kinect-Position-Tracking-Processing-Sketch/tree/main/testing%20and%20support) folder contains short scraps of code that we used for testing various functions such as sending serial, communicating through the server etc. Of particular interest is the [Testing 2 Kinects](https://github.com/SamIAm2000/Kinect-Position-Tracking-Processing-Sketch/tree/main/testing%20and%20support/Testing%202%20Kinects/sketch_2_kinects) folder where it displays the images from all three cameras (video, infrared, depth) of the 2 Kinects at once. Use this to troubleshoot Kinect problems.
