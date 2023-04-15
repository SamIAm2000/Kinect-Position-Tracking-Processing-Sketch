// Draw depth data as point cloud
void getDepth(Kinect2 kinect2) {

  // We're just going to calculate and draw every 2nd pixel
  int skip = RESOLUTION;

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();

  pg.noStroke();
  pg.fill(255);
  for (int x = 0; x < kinect2.depthWidth; x+=skip) {
    for (int y = 0; y < kinect2.depthHeight; y+=skip) {
      int offset = x + y * kinect2.depthWidth;
      float d = depth[offset];
      
      // Ignore stuff that is too close or too far.
      //if (d < MIN_D || d > MAX_D) continue;
      if (d > MAX_D) continue;

      //calculte the x, y camera position based on the depth information
      PVector point = depthToPointCloudPos(x, y, d);

      // Scale and draw a point
      pg.rect(point.x, point.y, 10/mm2px, 10/mm2px);
    }
  }
} 

//calculte the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}

//camera information based on the Kinect v2 hardware
static class CameraParams {
  static float cx = 254.878f;
  static float cy = 205.395f;
  static float fx = 365.456f;
  static float fy = 365.456f;
  static float k1 = 0.0905474;
  static float k2 = -0.26819;
  static float k3 = 0.0950862;
  static float p1 = 0.0;
  static float p2 = 0.0;
}