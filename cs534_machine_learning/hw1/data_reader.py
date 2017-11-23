#!/usr/bin/python

import csv
import numpy as np


def get_binary_features(data_set, featureList=None):
    print("Loading Binary Data")
    if featureList is None:
        featureList = get_binary_feature_vector(data_set)

    X, Y = get_binary_vector(data_set, featureList)

    print("Data Loaded")

    return X, Y, featureList


def get_binary_feature_vector(data_set):
    feature_dict = {}

    with open(data_set, 'rt') as csvfile:

        reader = csv.reader(csvfile, delimiter=',')

        count = 0

        for num_row, row in enumerate(reader):
            for i, item in enumerate(row):
                if i != len(row) - 1:
                    if (i, item) not in feature_dict:
                        feature_dict[i, item] = count
                        count += 1

    print(list(feature_dict.keys()))
    print(len(feature_dict.keys()))
    return feature_dict


def get_binary_vector(data_set, feature_list):
    with open(data_set, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')

        for num_row, row in enumerate(reader):

            if num_row % 1000 == 0:
                print(num_row)

            if num_row == 0:
                X = np.zeros((1, len(feature_list.keys()) + 1))
                Y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        Y[0] = -1
                    elif item == ' >50K':
                        Y[0] = 1
                    else:
                        X[0, feature_list[i, item]] = 1
                        X[0, -1] = 1
            else:
                x = np.zeros((1, len(feature_list.keys()) + 1))
                y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        y[0] = -1
                    elif item == ' >50K':
                        y[0] = 1
                    else:
                        x[0, feature_list[i, item]] = 1
                        x[0, -1] = 1

                X = np.vstack([X, x])
                Y = np.vstack([Y, y])

    return X, Y


def get_numbered_features(data_set, featureList=None):
    print("Loading Numbered Data")
    if featureList is None:
        featureList = get_numbered_feature_vector(data_set)

    X, Y = get_numbered_vector(data_set, featureList)

    print("Data Loaded")

    return X, Y, featureList


def get_numbered_vector(data_set, feature_list):
    with open(data_set, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')

        for num_row, row in enumerate(reader):

            if num_row % 1000 == 0:
                print(num_row)

            if num_row == 0:
                X = np.zeros((1, len(feature_list) + 3))
                Y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        Y[0] = -1
                    elif item == ' >50K':
                        Y[0] = 1
                    elif i == 0:
                        X[0, -3] = int(item)
                    elif i == 7:
                        X[0, -2] = int(item)
                    else:
                        X[0, feature_list.index(item)] = 1
                        X[0, -1] = 1
            else:
                x = np.zeros((1, len(feature_list) + 3))
                y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        y[0] = -1
                    elif item == ' >50K':
                        y[0] = 1
                    elif i == 0:
                        x[0, -3] = int(item)
                    elif i == 7:
                        x[0, -2] = int(item)
                    else:
                        x[0, feature_list.index(item)] = 1
                        x[0, -1] = 1

                X = np.vstack([X, x])
                Y = np.vstack([Y, y])

    return X, Y


def get_numbered_feature_vector(data_set):
    feature_list = []

    with open(data_set, 'rt') as csvfile:

        reader = csv.reader(csvfile, delimiter=',')

        for num_row, row in enumerate(reader):
            for i, item in enumerate(row):
                count = 0
                if i != len(row) - 1 and i != 0 and i != 7:
                    if num_row == 0:
                        feature_list.append([])
                        feature_list[count].append(item)
                    elif item not in feature_list[count]:
                        feature_list[count].append(item)
                count += 1

        full_list = []
        for j, item in enumerate(feature_list):
            full_list += feature_list[j]

    return full_list


def get_numbered_binary_features(data_set, featureList=None):
    print("Loading Numbered/Binary Data")
    if featureList is None:
        featureList = get_binary_feature_vector(data_set)

    X, Y = get_numbered_binary_vector(data_set, featureList)

    print("Data Loaded")

    return X, Y, featureList


def get_numbered_binary_vector(data_set, feature_list):
    with open(data_set, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')

        for num_row, row in enumerate(reader):

            if num_row % 1000 == 0:
                print(num_row)

            if num_row == 0:
                X = np.zeros((1, len(feature_list) + 3))
                Y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        Y[0] = -1
                    elif item == ' >50K':
                        Y[0] = 1
                    else:
                        X[0, feature_list.index(item)] = 1
                        X[0, -1] = 1
                        if i == 0:
                            X[0, -3] = int(item)
                        if i == 7:
                            X[0, -2] = int(item)
            else:
                x = np.zeros((1, len(feature_list) + 3))
                y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        y[0] = -1
                    elif item == ' >50K':
                        y[0] = 1
                    else:
                        x[0, feature_list.index(item)] = 1
                        x[0, -1] = 1
                        if i == 0:
                            x[0, -3] = int(item)
                        if i == 7:
                            x[0, -2] = int(item)

                X = np.vstack([X, x])
                Y = np.vstack([Y, y])

    return X, Y


def get_binned_features(data_set, featureList=None):
    print("Loading Binned Data")
    if featureList is None:
        featureList = get_numbered_feature_vector(data_set)

    X, Y = get_binned_vector(data_set, featureList)

    print("Data Loaded")

    return X, Y, featureList


def get_binned_vector(data_set, feature_list):
    with open(data_set, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')

        for num_row, row in enumerate(reader):

            if num_row % 1000 == 0:
                print(num_row)

            if num_row == 0:
                X = np.zeros((1, len(feature_list) + 13))
                Y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        Y[0] = -1
                    elif item == ' >50K':
                        Y[0] = 1
                    elif i == 0:
                        index = int(item) / 10
                        if index == 0:
                            index = 1
                        if index > 6:
                            index = 6
                        X[0, -14 + index] = 1
                    elif i == 7:
                        h = int(item)
                        if h < 25:
                            index = -7
                        elif h < 35:
                            index = -6
                        elif h < 45:
                            index = -5
                        elif h < 55:
                            index = -4
                        elif h < 65:
                            index = -3
                        else:
                            index = -2
                        X[0, index] = 1
                    else:
                        X[0, feature_list.index(item)] = 1
                        X[0, -1] = 1
            else:
                x = np.zeros((1, len(feature_list) + 13))
                y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        y[0] = -1
                    elif item == ' >50K':
                        y[0] = 1
                    elif i == 0:
                        index = int(item) / 10
                        if index == 0:
                            index = 1
                        if index > 6:
                            index = 6
                        x[0, -14 + index] = 1
                    elif i == 7:
                        h = int(item)
                        if h < 25:
                            index = -7
                        elif h < 35:
                            index = -6
                        elif h < 45:
                            index = -5
                        elif h < 55:
                            index = -4
                        elif h < 65:
                            index = -3
                        else:
                            index = -2
                        x[0, index] = 1
                    else:
                        x[0, feature_list.index(item)] = 1
                        x[0, -1] = 1

                X = np.vstack([X, x])
                Y = np.vstack([Y, y])

    return X, Y


def get_num_ed_features(data_set, featureList=None):
    print("Loading Numerical Eduation Data")
    if featureList is None:
        featureList = get_num_ed_feature_vector(data_set)

    X, Y = get_num_ed_vector(data_set, featureList)

    print("Data Loaded")

    return X, Y, featureList


def get_num_ed_feature_vector(data_set):
    feature_list = []

    with open(data_set, 'rt') as csvfile:

        reader = csv.reader(csvfile, delimiter=',')

        for num_row, row in enumerate(reader):
            for i, item in enumerate(row):
                count = 0
                if i != len(row) - 1 and i != 2:
                    if num_row == 0:
                        feature_list.append([])
                        feature_list[count].append(item)
                    elif item not in feature_list[count]:
                        feature_list[count].append(item)
                count += 1

        full_list = []
        for j, item in enumerate(feature_list):
            full_list += feature_list[j]

    return full_list


def get_num_ed_vector(data_set, feature_list):
    ed_dict = {' Preschool': 1, ' 1st-4th': 2, ' 5th-6th': 3, ' 7th-8th': 4, ' 9th': 5, ' 10th': 6, ' 11th': 7,
               ' 12th': 8, ' HS-grad': 9, ' Some-college': 10, ' Assoc-acdm': 11, ' Assoc-voc': 12, ' Prof-school': 13,
               ' Bachelors': 14, ' Masters': 15, ' Doctorate': 16}

    with open(data_set, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')

        for num_row, row in enumerate(reader):

            if num_row % 1000 == 0:
                print(num_row)

            if num_row == 0:
                X = np.zeros((1, len(feature_list) + 2))
                Y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        Y[0] = -1
                    elif item == ' >50K':
                        Y[0] = 1
                    elif i == 2:
                        X[0, -2] = ed_dict[item]
                    else:
                        X[0, feature_list.index(item)] = 1
                        X[0, -1] = 1
            else:
                x = np.zeros((1, len(feature_list) + 2))
                y = np.zeros((1, 1))
                for i, item in enumerate(row):
                    if item == ' <=50K':
                        y[0] = -1
                    elif item == ' >50K':
                        y[0] = 1
                    elif i == 2:
                        x[0, -2] = ed_dict[item]
                    else:
                        x[0, feature_list.index(item)] = 1
                        x[0, -1] = 1

                X = np.vstack([X, x])
                Y = np.vstack([Y, y])

    return X, Y


if __name__ == "__main__":
    X, Y = get_binary_features('../income-data/income.train.txt')

# print (X[0])
# print (Y[0])
