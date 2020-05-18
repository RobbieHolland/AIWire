import numpy as np

def get_biggest_spline(points, epsilon=1e-3):
    points = np.array(points)
    current_spline = [points[0]]
    biggest_spline = []
    for i in range(1, len(points)):
        p = points[i - 1]
        q = points[i]
        if np.sum((p - q) ** 2) <= 2 + epsilon:
            # Add to current spline
            current_spline.append(q)
        else: 
            # End of current spline
            if len(current_spline) > len(biggest_spline):
                biggest_spline = current_spline
            current_spline = [q]
    
    if len(current_spline) > len(biggest_spline):
        biggest_spline = current_spline


    return np.array(biggest_spline)

