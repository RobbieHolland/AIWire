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


