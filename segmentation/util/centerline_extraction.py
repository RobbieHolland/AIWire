import sys
sys.path.append("../") # go to parent dir
sys.path.append("../extract_centerline/")
sys.path.append("../extract_centerline/bin/")
sys.path.append("util/")
import os
import wireskeletonise 
import subprocess 
import numpy as np
from get_biggest_spline import * 

def PtsListFromFile(_fileName):
    ptsList = []
    f = open(_fileName, 'r')
    while(True):
        line = f.readline()
        if len(line) == 0:
            break
        vec = []
        line = line.rstrip()
        list = line.split()
        for i in range(0, len(list)):
            vec.append(float(list[i]))
        ptsList.append(vec)
    f.close()
    return ptsList
    img = img.astype(np.float32)

def get_centerline(img,directory,name): 
    img = img.astype(np.float32)
    os.chdir("../")
    file_dir = os.getcwd() + '/extract_centerline/example/'
    wireskeletonise.preAmbrosini(img, file_dir+name)
    os.chdir(file_dir)
    result = subprocess.call(['sh','./extract_centerline.sh'])
    pt_list = PtsListFromFile(file_dir + name + '.txt')
    pts = np.array(pt_list)
    # Apply get biggest spline to points 
    # pts = get_biggest_spline(pts)
    centerline = np.zeros_like(img)

    for ww in range(len(pts)):
        if int(pts[ww,1]) < centerline.shape[0] and int(pts[ww,0])< centerline.shape[1]:
            centerline[int(pts[ww,1]),int(pts[ww,0])] = 1
    os.chdir(directory)
    return centerline, pts
