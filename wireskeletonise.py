import numpy as np
from skimage.morphology import skeletonize
import matplotlib.pyplot as plt
import cv2
import uuid
from PIL import Image

# The code post-processes a binary image to make it compatible for the spline extraction
# It fills in gaps and broken lines by dilating and eroding the image.
# It saves the output skeleton as a .png file

def preAmbrosini(image,filename):
    # VERSION 1: adjust kernel dimension to image size, same kernel for both dilation and erosion
    # tip difference of 1 pixel
    kernel_di = np.ones((math.floor(image.shape[0] ** (1. / 3)), math.floor(image.shape[1] ** (1. / 3))), np.uint8)
    dilate_im = cv2.dilate(image, kernel_di, iterations=1)
    # plt.imshow(dilate_im)
    erode_im = cv2.erode(dilate_im, kernel_di, iterations=1)
    # skeletonise
    skeleton = skeletonize(erode_im)

    # VERSION 2: increase kernel size,same kernel for both dilation and erosion
    # tip difference of 1 pixel, but slightly different shape
    kernel_di = np.ones((math.floor(image.shape[0] ** (1. / 2.5)), math.floor(image.shape[1] ** (1. / 2.5))), np.uint8)
    dilate_im = cv2.dilate(image, kernel_di, iterations=1)
    # plt.imshow(dilate_im)
    erode_im = cv2.erode(dilate_im, kernel_di, iterations=1)
    # skeletonise
    skeleton = skeletonize(erode_im)

    # VERSION 3: smaller filter, but no erosion
    # tip difference of 1 pixel
    kernel_di = np.ones((math.floor(image.shape[0] ** (1. / 4)), math.floor(image.shape[1] ** (1. / 4))), np.uint8)
    dilate_im = cv2.dilate(image, kernel_di, iterations=1)
    # plt.imshow(dilate_im)
    # skeletonise
    skeleton = skeletonize(dilate_im)

    # VERSION 4 : larger dilating filter but smaller eroding filter
    # tip difference of 1 pixel
    kernel_di = np.ones((math.floor(image.shape[0] ** (1. / 3)), math.floor(image.shape[1] ** (1. / 3)), np.uint8)
    dilate_im = cv2.dilate(image, kernel_di, iterations=1)
    #plt.imshow(dilate_im)
    kernel_er = np.ones((math.floor(image.shape[0] ** (1. / 4)), math.floor(image.shape[1] ** (1. / 4)), np.uint8)
    erode_im = cv2.erode(dilate_im, kernel_er, iterations=1)
    #plt.imshow(erode_im)
    #skeletonise
    skeleton = skeletonize(erode_im)

    ##ORIGINAL FROM HERE
    #dilate and erode
    kernel_di = np.ones((5,3), np.uint8)
    dilate_im = cv2.dilate(image, kernel_di, iterations=1)
    #plt.imshow(dilate_im)
    kernel_er = np.ones((5,3), np.uint8)
    erode_im = cv2.erode(dilate_im, kernel_er, iterations=1)
    #plt.imshow(erode_im)

    #skeletonise
    skeleton = skeletonize(erode_im)
    #plt.imshow(skeleton)

    #save image without white frame, labels and else
    binary = Image.fromarray(skeleton)
    #filename = uuid.uuid4().hex
    format = ".png"
    binary = binary.save(filename+format)

    return binary
