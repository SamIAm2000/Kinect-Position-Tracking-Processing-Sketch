import dubins
import math
x0 = 0
y0 = 0
theta0 = math.pi/2

x1 = 0
y1 = 2
theta1 = math.pi/2

q0 = (x0, y0, theta0)
q1 = (x1, y1, theta1)
turning_radius = 1.0
step_size = 0.5

path = dubins.shortest_path(q0, q1, turning_radius)
print(path)
configurations, _ = path.sample_many(step_size)

for c in configurations:
    print(c)
# import dubins
# import math

# q0 = (0.0, 0.0, math.pi/4)
# q1 = (-4.0, 4.0, -math.pi)
# turning_radius = 1.0
# step_size = 0.5

# qs, _ = dubins.path_sample(q0, q1, turning_radius, step_size)
# print(qs)