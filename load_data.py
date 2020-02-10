import scipy.io
import os

def load_data(dataset_path, dataset_name):
    dataset = scipy.io.loadmat(os.path.join(dataset_path, dataset_name) + '.mat')['dataset']

    X = dataset[0]
    y = dataset[1]

    return X, y
