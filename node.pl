%Node in a neural network: Sigmoid activation function
%Sum the input, apply sigmoid function, output result

activation_function(X,Y) :- Y is 1/(1+(e^(-1*X))).
