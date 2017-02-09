:- dynamic(layer/3).
:- dynamic(weight/3).
:- dynamic(weight/4).
%Node in a neural network: Sigmoid activation function
%Sum the input, apply sigmoid function, output result

activation_function(SummedInput,Output) :- Output is 1/(1+(e^(-1*SummedInput))).

%neural_network(Input_Nodes, Hidden_Layers, Hidden_Nodes (Per Layer), Layers	
%Get an input vector: each goes to a corresponding input node
%There's a list for the outputs of each layer.
%

%layer(Layer_Number, Outputs).
%Change this name to something more meaningful, but this starts an iteration
initialize_inputs(Inputs) :-
	retractall(layer(0,_Y)), assertz(layer(0, Inputs)).
initialize_layer(Layer, Number_Of_Nodes) :-
	retractall(layer(Layer,_Node_Num)), initialize_outputs(Number_Of_Nodes, Outputs), assertz(layer(Layer,Outputs)). %Initialize weights goes in whatever calls this as it will know how many layers there are and how many nodes in each layer
initialize_outputs(0,[]).
initialize_outputs(N,[0|Outputs]) :- 
	N2 is N-1, initialize_outputs(N2, Outputs).
initialize_weights(0, _).
initialize_weights(_, 0).
%Input nodes
initialize_weights(1, Number_Of_Nodes) :- 
	random(Weight), assertz(weight(1, Number_Of_Nodes, Weight)), Number_Of_Nodes2 is Number_Of_Nodes-1, initialize_weights(1, Number_Of_Nodes2).
%
initialize_weights(Layer, Number_Of_Nodes) :-
	Previous is Layer-1, layer(Previous, Outputs), size_of(Outputs, Num_Previous), initialize_weights(Layer, Num_Previous, Number_Of_Nodes), Number_Of_Nodes2 is Number_Of_Nodes-1, initialize_weights(Layer, Number_Of_Nodes2).

initialize_weights(_Layer,0,_Node_Number).
initialize_weights(Layer, Num_Previous, Node_Number) :-
	random(Weight), assertz(weight(Layer, Num_Previous, Node_Number,Weight)), Num_Previous2 is Num_Previous-1, initialize_weights(Layer, Num_Previous2, Node_Number).

size_of([], 0).
size_of([_H|T], Number) :- 
	size_of(T, Number2), Number is Number2+1.
	

output(1, Node_Number) :-
	layer(0, Inputs), get_at_index(Inputs,Node_Number, Input), apply_weight(Node_Number, Input, Result).

%Special case: For the inputs there is no prior layer, so we only have one node involved
apply_weight(Input_Number, Input, Result) :-
	weight(Input_Number, Weight), Result is Weight*Input.

get_at_index([H|_T], 0, H).
get_at_index([H|T], Index, Item) :-
	Index2 is Index-1, get_at_index(T, Index2, Item).
