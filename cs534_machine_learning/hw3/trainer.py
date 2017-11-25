#!/usr/bin/env python

from __future__ import print_function
# from collections import defaultdict
import sys
import time
import copy
import matplotlib.pyplot as plt
plt.switch_backend('agg')
from tagger import readfile, mle, decode, test
from tagger_tri import readfile_tri, mle_tri, decode_tri, test_tri

startsym, stopsym = "<s>", "</s>"


def unavg_perc_train(trainfile, devfile, dictionary, model):
    print("-------------------------------------------------------")
    print("UNAVERAGED PERCEPTRON - BIGRAM")
    updates = 0
    epoch = 5
    lr = 1

    start = time.time()

    for i in range(epoch):
        for x_i, y_i in readfile(trainfile):
            z_i = decode(x_i, dictionary, model)
            if y_i != z_i:
                updates += 1
                phi_xy = phi(x_i, y_i)
                phi_xz = phi(x_i, z_i)
                for key in phi_xy:
                    if key not in phi_xz:
                        model[key] += lr * 1

                for key in phi_xz:
                    if key not in phi_xy:
                        model[key] -= lr * 1

        train_err = test(trainfile, dictionary, model)
        dev_err = test(devfile, dictionary, model)
        print("epoch:", i + 1, "updates:", updates, "train_err: {0:.2%}".format(train_err),
              "dev_err: {0:.2%}".format(dev_err))

    end = time.time()
    elap_time = end - start
    print("elapsed time:", elap_time)
    print("-------------------------------------------------------")


def avg_perc_train(trainfile, devfile, dictionary, model):
    print("-------------------------------------------------------")
    print("AVERAGED PERCEPTRON - BIGRAM")
    updates = 0
    c = 1
    epoch = 5
    lr = 1
    # weights = defaultdict(float)
    model_0 = copy.deepcopy(model)
    model_a = copy.deepcopy(model)

    start = time.time()

    for i in range(epoch):
        for x_i, y_i in readfile(trainfile):
            z_i = decode(x_i, dictionary, model_0)
            if y_i != z_i:
                updates += 1
                phi_xy = phi(x_i, y_i)
                phi_xz = phi(x_i, z_i)
                for key in phi_xy:
                    if key not in phi_xz:
                        model_0[key] += lr * 1
                        model_a[key] += c * lr * 1

                for key in phi_xz:
                    if key not in phi_xy:
                        model_0[key] -= lr * 1
                        model_a[key] -= c * lr * 1
            c += 1
        weights = {key: model_0[key] - model_a[key] / c for key in model}

        train_err = test(trainfile, dictionary, weights)
        dev_err = test(devfile, dictionary, weights)
        print("epoch:", i + 1, "updates:", c, "train_err: {0:.2%}".format(train_err),
              "dev_err: {0:.2%}".format(dev_err))

    end = time.time()
    elap_time = end - start
    print("elapsed time:", elap_time)
    print("-------------------------------------------------------")


def avg_perc_train_tri(trainfile, devfile, dictionary, model):
    print("-------------------------------------------------------")
    print("AVERAGED PERCEPTRON - TRIGRAM")
    updates = 0
    c = 1
    epoch = 5
    lr = 1
    # weights = defaultdict(float)
    model_0 = copy.deepcopy(model)
    model_a = copy.deepcopy(model)

    start = time.time()

    for i in range(epoch):
        for x_i, y_i in readfile_tri(trainfile):
            z_i = decode_tri(x_i, dictionary, model_0)
            if y_i != z_i:
                updates += 1
                phi_xy = phi2(x_i, y_i)
                phi_xz = phi2(x_i, z_i)
                for key in phi_xy:
                    if key not in phi_xz:
                        model_0[key] += lr * 1
                        model_a[key] += c * lr * 1

                for key in phi_xz:
                    if key not in phi_xy:
                        model_0[key] -= lr * 1
                        model_a[key] -= c * lr * 1
            c += 1
        weights = {key: model_0[key] - model_a[key] / c for key in model}

        train_err = test_tri(trainfile, dictionary, weights)
        dev_err = test_tri(devfile, dictionary, weights)
        print("epoch:", i + 1, "updates:", c, "train_err: {0:.2%}".format(train_err),
              "dev_err: {0:.2%}".format(dev_err))

    end = time.time()
    elap_time = end - start
    print("elapsed time:", elap_time)
    print("-------------------------------------------------------")


def phi(words, tags):
    phi_list = []
    # words = words + [stopsym]
    tags = tags + [stopsym]
    for i in range(len(tags)):
        if i == 0:
            first_tag = "<s>"
        else:
            first_tag = tags[i - 1]
        if i == len(tags):
            next_tag = "</s>"
        else:
            next_tag = tags[i]
        phi_list.append((first_tag, next_tag))

    for i in range(len(tags) - 1):
        phi_list.append((tags[i], words[i]))

    return phi_list


def phi2(words, tags):
    phi_list = []
    # words = words + [stopsym]
    tags = tags + [stopsym]
    for i in range(len(tags)):
        if i == 0:
            first_tag = "<s>"
        else:
            first_tag = tags[i - 1]
        if i == len(tags):
            next_tag = "</s>"
        else:
            next_tag = tags[i]
        phi_list.append((first_tag, next_tag))

    for i in range(len(tags) - 1):
        phi_list.append((tags[i], words[i]))

    for i in range(len(tags)):
        if i == 0 or i == 1:
            first_tag = "<s>"
        else:
            first_tag = tags[i - 2]
        if i == 1:
            next_tag = "<s>"
        else:
            next_tag = tags[i - 1]
        if i == len(tags):
            next_next_tag = "</s>"
        else:
            next_next_tag = tags[i]
        phi_list.append((first_tag, next_tag, next_next_tag))

    return phi_list


if __name__ == "__main__":
    trainfile, devfile, testfile = sys.argv[1:4]

    dictionary, model = mle(trainfile)
    dictionary_tri, model_tri = mle_tri(trainfile)

    print("BIGRAM")
    print("train_err {0:.2%}".format(test(trainfile, dictionary, model)))
    print("dev_err {0:.2%}".format(test(devfile, dictionary, model)))

    print("TRIGRAM")
    print("train_err {0:.2%}".format(test_tri(trainfile, dictionary_tri, model_tri)))
    print("dev_err {0:.2%}".format(test_tri(devfile, dictionary_tri, model_tri)))

    unavg_perc_train(trainfile, devfile, dictionary, model)
    avg_perc_train(trainfile, devfile, dictionary, model)
    avg_perc_train_tri(trainfile, devfile, dictionary_tri, model_tri)

    # for words, tags in readfile(devfile):
    #     print(phi2(words, tags))
    # for i in range(len(tags)):
    # print(i)
    # print(len(tags))

    epoch_vals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    unavg_train_errs = [2.86, 2.37, 2.24, 4.12, 1.83, 1.88, 2.07, 1.72, 1.96, 1.80]
    unavg_dev_errs = [6.43, 6.73, 6.43, 8.48, 5.56, 5.85, 7.02, 5.85, 5.56, 5.26]
    avg_train_errs = [1.42, 1.28, 1.25, 1.28, 1.23, 1.23, 1.23, 1.25, 1.23, 1.23]
    avg_dev_errs = [5.56, 5.26, 5.26, 5.56, 4.97, 4.97, 4.97, 4.97, 4.97, 4.97]

    plot1 = plt.plot(epoch_vals, unavg_train_errs, label="unavg_train_err")
    plot2 = plt.plot(epoch_vals, unavg_dev_errs, label="unavg_dev_err")
    plot3 = plt.plot(epoch_vals, avg_train_errs, label="avg_train_err")
    plot4 = plt.plot(epoch_vals, avg_dev_errs, label="avg_dev_err")
    plt.xlabel("Epochs")
    plt.ylabel("Error Rates (%)")
    plt.legend(loc="upper right")
    plt.savefig("err_rate_plot")

    output_file = open("dev.lower.unk.best", "w")
    for line in open(devfile):
        wordtags = map(lambda x: x.rsplit("/", 1), line.split())
        words = [w for w, t in wordtags]
        tags = decode_tri(words, dictionary_tri, model_tri)
        for word, tag in zip(words, tags):
            output_file.write(word + "/" + tag + " ")
        output_file.write("\n")

    output_file2 = open("test.lower.unk.best", "w")
    for line in open(testfile):
        words2 = line.split()
        tags2 = decode_tri(words2, dictionary_tri, model_tri)
        for word, tag in zip(words2, tags2):
            output_file2.write(word + "/" + tag + " ")
        output_file2.write("\n")