from data_reader import get_binary_features


def main():
    # If you do not have an existing feature vector
    data_set = "../machine_learning/income-data/income.train.txt.5k"
    X, Y, features = get_binary_features(data_set)

    # If you have an existing feature vector you want to compute against
    data_set = "../machine_learning/income-data/income.dev.txt"
    X_dev, Y_dev, features = get_binary_features(data_set, features)


if __name__ == "__main__":
    main()
