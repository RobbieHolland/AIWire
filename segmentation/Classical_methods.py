import cv2
import numpy as np 

def laplace_segmentation(image, threshold = 0.52):
    lp = -cv2.Laplacian(image, cv2.CV_64F, ksize=15)
    lp = lp - np.min(lp)
    lp = lp / np.max(lp)
    return lp > threshold

