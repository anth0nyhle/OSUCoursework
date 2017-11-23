from data_reader import get_binary_features
from sklearn import svm
import numpy as np
import matplotlib.pyplot as plt
import time


def main(C=1):
    # If you do not have an existing feature vector
    data_set = "../machine_learning/income-data/income.train.txt.5k"
    X, Y, features = get_binary_features(data_set)

    # If you have an existing feature vector you want to compute against
    data_set = "../machine_learning/income-data/income.dev.txt"
    X_dev, Y_dev, features = get_binary_features(data_set, features)

    Y = np.ravel(Y)
    Y_dev = np.ravel(Y_dev)

    # -----------------------------------------------------------------------------

    start = time.time()

    clf = svm.SVC(kernel='linear', C=C)
    clf.fit(X, Y)

    end = time.time()

    # -----------------------------------------------------------------------------

    supp_vec = clf.support_vectors_
    num_supp_vec = clf.n_support_

    train_score = clf.score(X, Y)
    train_error = 1.0 - train_score

    dev_score = clf.score(X_dev, Y_dev)
    dev_error = 1.0 - dev_score

    t = end - start

    # -----------------------------------------------------------------------------

    w = clf.coef_
    a = clf.dual_coef_

    sum_xi = 0.0

    xi_array = np.zeros((len(supp_vec[:, 0]), 1), dtype=np.float64)

    for i in range(len(supp_vec[:, 0])):
        xi = 1 - (1.0 * Y[clf.support_[i]] * np.inner(w, X[clf.support_[i], :]))
        xi_array[i, 0] = xi

    print("------------------Xi-------------------")
    print(xi_array.shape)
    print(xi_array)

    np.set_printoptions(threshold=np.nan)

    abs_xi_array = np.transpose(abs(xi_array))
    print(abs_xi_array.argsort())

    # print(abs_xi_array)

    print(xi_array[723, 0])
    print(xi_array[232, 0])
    print(xi_array[873, 0])
    print(xi_array[107, 0])
    print(xi_array[699, 0])

    # count = 0
    #
    # for j in range(len(xi_array[:, 0])):
    #     if abs(a[0, j]) == C and 0.0 < xi_array[j, 0]:
    #         sum_xi = sum_xi + xi_array[j, 0]
    #         count += 1
    #     else:
    #         pass
    #
    # margin_vio = count
    #
    # obj = (0.5 * ((np.linalg.norm(w)) ** 2)) + (C * sum_xi)
    #
    # print("-------------SUPPORT VECTORS-------------")
    # print(supp_vec.shape)
    # print(supp_vec)
    # print(clf.support_.shape)
    # print(clf.support_)
    # print("-------------PRIMAL VARIABLES------------")
    # print(w.shape)
    # print(w)
    # print("--------------DUAL VARIABLES-------------")
    # print(a.shape)
    # print(a)
    # print("-----------------------------------------")
    # print("For C =", C)
    # print("Number of Support Vectors:", num_supp_vec)
    # print("Number of Margin Violations:", margin_vio)
    # print("Total Amount of Margin Violations:", sum_xi)
    # print("Objective:", obj)
    # print("Training Error Rate:", train_error * 100)
    # print("Dev Error Rate:", dev_error * 100)
    # print("Intercept:", clf.intercept_)
    # print("Training Time:", t)
    # print("-----------------------------------------")

    # -----------------------------------------------------------------------------

    # C_list = [0.01, 0.1, 1, 2, 5, 10]
    # train_error_list = [17.86, 16.80, 15.72, 15.60, 15.46, 15.42]
    # dev_error_list = [16.38, 16.38, 16.05, 16.11, 15.78, 16.05]
    #
    # plt.plot(C_list, train_error_list)
    # plt.plot(C_list, dev_error_list)
    # plt.xlabel("C Value")
    # plt.ylabel("%")
    #
    # plt.legend(["Training Error Rate", "Dev Error Rate"], loc="upper right")
    #
    # plt.show()

    # -----------------------------------------------------------------------------

    # num_train_ex = [5, 50, 500, 5000]
    # train_time = [3.16, 3.46, 2.97, 2.93]
    #
    # plt.plot(num_train_ex, train_time)
    # plt.xlabel("Number of Training Examples")
    # plt.ylabel("Training Time (sec)")
    #
    # plt.show()


if __name__ == "__main__":
    main()
