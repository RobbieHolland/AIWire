import numpy as np
from skimage.morphology import skeletonize
import matplotlib.pyplot as plt
import PIL
from PIL import Image

#read file
image = plt.imread("trial.jpg")
slice = np.array(image[:,:,0])

#threashold and skeletonise image
black = 0*(slice<200)
binary = 1.0*(slice>200)
skeleton = skeletonize(binary)

#save image without white frame, labels and else
binary = Image.fromarray(skeleton)
binary = binary.save('binary.png')