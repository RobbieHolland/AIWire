import scipy.io
import os
import h5py 
import numpy as np

def load_data(dataset_path, dataset_name, v73=False):
    path = os.path.join(dataset_path, dataset_name) + '.mat'
    if v73:
        with h5py.File(path, 'r') as f: 
            data = {'dataset': np.moveaxis(np.array(f['dataset']), (0, 1, 2, 3), (3, 2, 1, 0)), 'spline_pts': np.array(f['spline_pts'])}
    else:
        data = scipy.io.loadmat(path)

    X = data['dataset'][0]
    y = data['dataset'][1]
    spline_pts = data['spline_pts']

    return X, y, spline_pts
