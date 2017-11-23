from perceptron import Perceptron
from data_reader import get_binary_features
from data_reader import get_numbered_binary_features, get_binned_features
from data_reader import get_num_ed_features


import numpy as np

xs = np.array([[1,-1,-1], [1,1,1], [-1,1,-1], [-1,-1,1]])
ys = np.array([-1, 1, -1, 1])

def main():
    data_set = "../income-data/income.train.txt"
    X, Y, features = get_binary_features(data_set)
    print (X.shape)

    data_set = "../income-data/income.dev.txt"
    X_dev, Y_dev, features = get_binary_features(data_set, features)
    print (X_dev.shape)

    perceptron = Perceptron(feature_size=len(X[0,:]))

    # print ("Before training:")
    # print(perceptron.test(X, Y))
    # perceptron.train(X,Y)

    # print("After (batch) training:")
    # print(perceptron.test(X, Y))

    perceptron.reset()

    for j in range(1):
        for i in range(len(X[:,0])):
            perceptron.train_online(X[i,:], Y[i])

    print ("After single training: ")
    print(perceptron.test(X,Y))

    print ("Average")
    perceptron.reset()
    perceptron.average_train(X, Y, maxIter=5)

    print ("Naive average (with maximum iterations)")
    perceptron.reset()
    perceptron.naive_average_train(X, Y, maxIter=10)

    print(perceptron.test(X,Y))
    print ("MIRA")
    mira = Perceptron(feature_size=len(X[0,:]), mira_aggro=0.0)
    for j in range(10):
        for i in range(len(X[:,0])):
            mira.train_mira(X[i,:], Y[i])

    print(mira.test(X,Y))


    print ("MIRA Average")
    mira.reset()
    mira.train_mira_average(X,Y, maxIter=5)
    print(mira.test(X,Y))
    
if __name__ == "__main__":
    main()