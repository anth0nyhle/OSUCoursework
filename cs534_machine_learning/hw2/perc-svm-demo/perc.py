import numpy as np
import sys
import math

prec = 1e-4
sign = lambda x: -1 if x < -prec else 1 if x > prec else 0

def perc(data, MIRA=False, aggressive=False, margin=0.5):

    weight = np.array([0.,0.,0.]) # must be float!
    avgw = np.array([0.,0.,0.])

    supp_vec = set()
    for i in range(10000):
        best_margin = 100000
        error = 0
        tavgw = np.array([0.,0.,0.])
        for j, ((x,y), label) in enumerate(data):
            point = np.array([x,y,1.])
            s = weight.dot(point)
            result = sign(s)
            if result != label or aggressive and math.fabs(s)<margin-prec:
                if MIRA:
                    ratio = (label-s) / point.dot(point)
                else:
                    ratio = label
                weight += point * ratio
                #print point, weight
                if MIRA:
                    assert math.fabs(weight.dot(point)-label)<prec
                error += 1
                supp_vec.add(j) # support vector set
            else:
                m = math.fabs(s) / np.linalg.norm(weight)
                if m < best_margin:
                    best_margin = m
            avgw += weight
        if error == 0:
            break
        else:
            #pass
            print(i, error, weight)
        #avgw += weight

    return i+1, weight, avgw, len(supp_vec), best_margin
