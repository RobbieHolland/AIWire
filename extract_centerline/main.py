import matplotlib.pyplot as plt
import numpy as np

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

path = "example/" # put your path here
file = path + "binary.txt"

pt_list = PtsListFromFile(file)
pt_list = np.array(pt_list)
print(pt_list.shape)

plt.figure()
plt.plot(pt_list[:,0], -pt_list[:,1],"o")
plt.show()
