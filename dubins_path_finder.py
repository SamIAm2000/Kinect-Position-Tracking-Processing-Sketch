import dubins
x0 = 0
y0 = 0
theta0 = 0

x1 = 2
y1 = 2
theta1 = 0

q0 = (x0, y0, theta0)
q1 = (x1, y1, theta1)
turning_radius = 1.0
step_size = 0.5

path = dubins.shortest_path(q0, q1, turning_radius)
configurations, _ = path.sample_many(step_size)