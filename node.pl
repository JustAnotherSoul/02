%Node in a neural network: Sigmoid activation function
%Sum the input, apply sigmoid function, output result

activation_function(SummedInput,Output) :- Output is 1/(1+(e^(-1*SummedInput))).

%Inputs, Output, Weights
%So the outputs are weighted, and the nodes are keyed. How do the inputs get handled?
%Is this fired from the bottom up or the top down?
%This is a wonderfully hard problem!!
% Okay: So firstly, representing the nodes.
% 	Secondly, using them!"
%Two styles perhaps. One representing it for saving, and the other for usage
%First test will be learning XOR:
%Two inputs
%Two hidden
%One output node
%Node Name, Node Layer
%node(0,0).
%node(1,0).
%node(2,1).
%node(3,1).
%node(4,2).

%Initial node, next node, weight
%node(0,2,0.5).
%node(0,3,0.5).
%node(1,2,0.5).
%node(1,3,0.5).
%node(2,4,0.5).
%node(3,4,0.5).

%So, the wrong approach is being taken here. This is a math thing, and I'm not in an object oriented language.
%So instead of defining individual nodes, define a neural network.
%neural_network(Input_Nodes, Hidden_Layers, Hidden_Nodes (Per Layer),
%Get an input vector: each goes to an input node
%Everything else there's a list for the previous layer's output that gets passed around (Backprop stuff?)
output(0,N,W,List,Output) :- 
	
