import matplotlib.pyplot as plt
import matplotlib.cm as cm
import numpy as np

def show_images(outputs, coords=None, height=10, title='', n=10):
    fig = plt.figure(figsize=[height, 3])
    for i, output in enumerate(outputs[:n]):
        plt.subplot(1,n,i+1)
        plt.axis('off')
        plt.imshow(output, cmap='gray')
        if coords: 
            colors = cm.rainbow(np.linspace(0, 1, len(coords)))
            for pts,c in zip(coords,colors):
                plt.scatter(pts[len(pts)-1,0],pts[len(pts)-1,1],color=c)
        plt.title(title)
    plt.show()


