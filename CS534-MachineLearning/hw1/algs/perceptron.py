import numpy as np

class Perceptron(object):
    def __init__(self, learning_rate=1, input_data=None, output_data=None,
                 feature_size=None, mira_aggro=0):
        self.lr = learning_rate
        self.mira_margin = mira_aggro
        
        if feature_size is not None:
            self.dims = feature_size
        elif input_data is not None:
            self.dims = input_data.shape[1]
        else:
            raise "Perceptron must be able to initialize weight vector."

        self.w = np.zeros(self.dims)

        if input_data is not None and output_data is not None:
            self.train(input_data, output_data)
        
    # Batch train
    def train(self, xs, ys):
        num_features = xs.shape[0]
        if not num_features == ys.shape[0]:
            raise "All data must be labeled."

        error = np.transpose(ys - np.reshape(self.predict(xs),ys.shape))

        self.w += self.lr * np.dot(error,xs)

    def predict(self, xs):
        output = np.dot(xs, self.w)
        return np.reshape(np.vectorize(self.f)(output),(len(xs[:,0]),1))


    # Indicator of if perceptron corectly classified output
    def f(self,x):
        return 1.0 if x >= 0 else -1.0

    
    def predict_single(self, x):
        output = np.inner(x, self.w)
        return self.f(output)

    # Train online
    def train_online(self, x, y):
        if self.predict_single(x) * y <= 0:
            self.w += self.lr * y * x


    def naive_average_train(self, xs, ys, maxIter=None):
        c = 0
        wp = np.zeros(self.dims)
        i = 0
        while(self.test(xs,ys) != 1 and (maxIter is not None and i < maxIter)): 
            
            for x,y in zip(xs,ys):
                c += 1
                if self.predict_single(x)*y <= 0:
                    self.w += self.lr * y * x
                wp += self.w
            i += 1
        self.w = wp / c

    def average_train(self, xs, ys, maxIter=None):
        c = 0
        wa = np.zeros(self.dims)
        i = 0
        while(self.test(xs,ys) != 1 and (maxIter is not None and i < maxIter)):
            print "iteration: ", i
            for x, y in zip(xs,ys):
                c += 1
                if self.predict_single(x)*y <= 0:                  
                    self.w += self.lr * y * x
                    wa += c * self.lr * y * x
            i += 1

        self.w -= wa / c

    def train_mira(self, x, y):
        dotp = np.inner(x, self.w)
        if dotp*y <= self.mira_margin:
            self.w = self.w + self.lr * (y - dotp) * x / self.square_norm(x)

    def train_mira_average(self, xs, ys, maxIter=None):
        c = 0
        wp = np.zeros(self.dims)
        i = 0
        while(self.test(xs,ys) != 1 and (maxIter is not None and i < maxIter)): 
            
            for x,y in zip(xs,ys):
                c += 1
                dotp = np.inner(x, self.w)
                if dotp*y <= self.mira_margin:
                    self.w = self.w + self.lr * (y - dotp) * x / self.square_norm(x)
                wp += self.w
            i += 1

        self.w = wp / c
        
    # Returns the classification percentage on the output data
    def test(self, input_data, output_data):
        if len(output_data) == 0:
            return 1

        return np.sum(self.predict(input_data) == (output_data)) / (1.0 * len(output_data))
        
            
    def safe_norm(self):
        norm = np.linalg.norm(self.w)
        if norm == 0:
            return
        self.w /= norm

    def square_norm(self, x):
        return (lambda i : i * i)(np.linalg.norm(x))
    
    def reset(self):
        self.w = np.zeros(self.dims)
