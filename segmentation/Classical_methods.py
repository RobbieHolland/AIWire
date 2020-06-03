import cv2
import numpy as np 
from scipy.ndimage import gaussian_filter

def laplace_segmentation(image, sigma = 7, threshold = 0.5):
    image = gaussian_filter(image, sigma=sigma)
    lp = -cv2.Laplacian(image, cv2.CV_64F, ksize=15)
    lp = lp - np.min(lp)
    lp = lp / np.max(lp)
#     return image, lp# > threshold
    return lp > threshold

def laplace_segmentation_old(image, threshold = 0.52):
    lp = -cv2.Laplacian(image, cv2.CV_64F, ksize=150)
    lp = lp - np.min(lp)
    lp = lp / np.max(lp)
    return lp > threshold