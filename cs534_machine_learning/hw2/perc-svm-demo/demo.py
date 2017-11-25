#!/usr/bin/env python

import sys
import os
import math
import numpy as np
from random import random, randint
from matplotlib import pyplot
from sklearn import svm

from perc import sign, perc

dim = 2
N = 500


def gen(C=1e10):
    a, b, c = (random() - 0.5) * 10, (random() - 0.5) * 10, (random() + 1) * 5  # 0 for no bias
    norm = math.sqrt(a * a + b * b)

    w = np.array([a / norm, b / norm, c / norm])

    prec = 1e-2
    data = [[], []]
    datas = []
    X = []
    Y = []
    while not all(len(d) >= 20 for d in data):
        xy = np.array([(random() - 0.5) * 20, (random() - 0.5) * 20, 1])
        c = w.dot(xy)
        if c >= 1:
            i = 0
        elif c <= -1:
            i = 1
        else:
            i = 2
        if i < 2 and len(data[i]) <= 20:
            ##         if random()<0.99:
            ##             i = 1-i; c = -c
            data[i].append((xy[0], xy[1]))
            datas.append(((xy[0], xy[1]), sign(c)))
            X.append(xy[:-1])
            Y.append(sign(c))

    markers = ["ro", "bs"]
    for i, d in enumerate(data):
        ps = np.array(d).transpose()
        pyplot.plot(ps[0], ps[1], markers[i], ms=5)

    x = np.linspace(-10, 10, 21)

    #     pyplot.plot(x, (w[0]*x + w[2])/-w[1])
    #     pyplot.plot(x, (w[0]*x + w[2] + 1)/-w[1])
    #     pyplot.plot(x, (w[0]*x + w[2] - 1)/-w[1])

    #    percw, _ = perc(datas, MIRA=False, aggressive=False)
    e1, percw, avgw, errp, marginp = perc(datas, MIRA=False, aggressive=False, margin=0)
    e2, miraw, _, erra, margina = perc(datas, MIRA=True, aggressive=False, margin=0.2)
    e3, miraw2, _, erra2, margina2 = perc(datas, MIRA=True, aggressive=True, margin=0.5)
    print(e1, e2, e3)
    print(percw, avgw)
    print(np.linalg.norm(percw), np.linalg.norm(avgw))
    print(marginp, margina)
    print(errp, erra)

    pyplot.plot(x, (percw[0] * x + percw[2]) / -percw[1], "--", linewidth=0.2, label='perc')  # PERC
    # pyplot.plot(x, (miraw[0]*x + miraw[2])/-miraw[1], "-.") # MIRA
    # pyplot.plot(x, (miraw2[0]*x + miraw2[2])/-miraw2[1], "-.", label='aggress. MIRA') # agg. MIRA

    print(X.shape)
    print(Y.shape)
    clf = svm.SVC(kernel='linear', C=C)
    clf.fit(X, Y)
    print("support vectors")
    print(clf.support_vectors_)
    svmmodel = np.concatenate((clf.coef_[0], clf.intercept_))
    print("model (primal)")
    print(svmmodel)
    print(clf.dual_coef_)
    pyplot.plot(x, (svmmodel[0] * x + svmmodel[2]) / -svmmodel[1], "k-", linewidth=2.0, label='svm')  # SVM
    pyplot.plot(x, (svmmodel[0] * x + 1 + svmmodel[2]) / -svmmodel[1], "-.", linewidth=1.0)
    pyplot.plot(x, (svmmodel[0] * x - 1 + svmmodel[2]) / -svmmodel[1], "-.", linewidth=1.0)

    for ps, alpha in zip(clf.support_vectors_, clf.dual_coef_[0]):
        if abs(alpha) == C:  # violating support vectors: alpha == C
            pyplot.plot(ps[0], ps[1], "D", ms=10, markeredgecolor='g', markerfacecolor='None')
            pyplot.text(ps[0] + 0.2, ps[1] - 0.8, "%.1f" % (1 - sign(alpha) * (svmmodel.dot([ps[0], ps[1], 1]))),
                        color='red')  # show slack
        else:  # good support vectors: 0 < alpha < C
            pyplot.plot(ps[0], ps[1], "o", ms=12, markeredgecolor='g', markerfacecolor='None')
            pyplot.text(ps[0] + 0.2, ps[1] + 0.2, "%.4f" % abs(alpha), color='gray')  # show alpha

    pyplot.title("SVM C=%s" % C)
    pyplot.legend(loc=2)
    pyplot.xlim(-10, 10)
    pyplot.ylim(-10, 10)
    pyplot.xticks(x)
    pyplot.yticks(x)


if __name__ == "__main__":

    C = float(sys.argv[1]) if len(sys.argv) > 1 else 0.01
    pyplot.ion()
    while True:
        gen(C=C)
        pyplot.show()
        try:
            a = raw_input()
        except:
            break
        pyplot.clf()
