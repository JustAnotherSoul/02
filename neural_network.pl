:- use_module(library(random)).

%An attempt at an implementation that does not manipulate the database at all.

%Initialize neural network initializes the neural net with the specified number of layers, the specified nodes per layer ([input, hidden, outputs]), and random weights.
%NeuralNetwork is a simple neural_network with weights and nodes, and is stored in a tree structure
initialize_neural_network(Layers, Nodes_Per_Layer, Neural_Network).

%Base case for getting a list of a given length. No more elements to add, so finish the list
get_list(0, []).
%Operating case: 
get_list(Num_Elements, [0|List]) :- 
	Num_Elements2 is Num_Elements-1,
	get_list(Num_Elements2, List).

%Base case for initializing a given length list of random weights
get_weights(0, []).
%Operating case
get_weights(Num_Weights, [Rand_Weight | List]) :-
	Num_Weights2 is Num_Weights -1,
	random(Rand_Weight),
	get_weights(Num_Weights2, List).

%The core initialization piece. The number of layers, including input and output layers 
%Might jsut want to make it number of hidden layers in that case...
%The Input_nodes, Hidden_Nodes, and Output_Nodes are input parameters that determine what gets generated
initialize_layers(Layers, [Input_Nodes, Hidden_Nodes, Output_Nodes], Layers_List) :-
	Hidden_Layers is Layers-2, 
	get_list(Output_Nodes, Output_List),
    length(Output_List, OL),
    get_weights(OL, Output_List2),
	get_list(Input_Nodes, Input_List),
    length(Input_List, IL),
    get_weights(IL, Input_List2),
	get_list(Hidden_Nodes, Hidden_List),
    length(Hidden_List, HL),
    get_weights(HL, Hidden_List2),
	add_list(Hidden_Layers_List, Input_List2, Input_Hidden_Layers_List),
	add_to_end(Input_Hidden_Layers_List, Output_List2, Layers_List),
	get_hidden_layers(Hidden_Layers, Hidden_List2, Hidden_Layers_List).

%Add an element to the end of a list
add_to_end([], H2, [H2]).
add_to_end([H|T], H2, [H|List]) :-
	add_to_end(T, H2, List).

%Add a list to another list
add_list([H|T], H2, [H2,H|T]).

%Add the hidden layers lists together
get_hidden_layers(0, Hidden_List, []).
get_hidden_layers(Num_Hidden_Layers, Hidden_List, [Hidden_List | Hidden_Layers]) :- 
	Num_Hidden_Layers2 is Num_Hidden_Layers - 1,
	get_hidden_layers(Num_Hidden_Layers2, Hidden_List, Hidden_Layers).	
