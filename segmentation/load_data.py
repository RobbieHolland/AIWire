import scipy.io
import os

def load_data(dataset_path, dataset_name, spline_pts=False):
    data = scipy.io.loadmat(os.path.join(dataset_path, dataset_name) + '.mat')
    image_data = data['dataset']

    X = image_data[0]
    y = image_data[1]

    if spline_pts:
        return X, y, data['spline_pts']

    return X, y
