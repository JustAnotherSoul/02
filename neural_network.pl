:- use_module(library(random)).

%An attempt at an implementation that does not manipulate the database at all.

%Initialize neural network initializes the neural net with the specified number of layers, the specified nodes per layer ([input, hidden, outputs]), and random weights.
%NeuralNetwork is a simple neural_network with weights and nodes, and is stored in a tree structure
initialize_neural_network(Layers, Nodes_Per_Layer, Neural_Network).

get_list(0, []).
get_list(Num_Elements, [0|List]) :- 
	Num_Elements2 is Num_Elements-1,
	get_list(Num_Elements2, List).

get_weights(0, []).
get_weights(Num_Weights, [Rand_Weight | List]) :-
	Num_Weights2 is Num_Weights -1,
	random(Rand_Weight),
	get_weights(Num_Weights2, List).

initialize_layers(Layers, [Input_Nodes, Hidden_Nodes, Output_Nodes], Layers_List) :-
	Hidden_Layers is Layers-2, 
	get_list(Output_Nodes, Output_List),
	get_list(Input_Nodes, Input_List),
	get_list(Hidden_Nodes, Hidden_List),
	add_list(Hidden_Layers_List, Input_List, Input_Hidden_Layers_List),
	add_to_end(Input_Hidden_Layers_List, Output_List, Layers_List),
	get_hidden_layers(Hidden_Layers, Hidden_List, Hidden_Layers_List).


add_to_end([], H2, [H2]).
add_to_end([H|T], H2, [H|List]) :-
	add_to_end(T, H2, List).
add_list([H|T], H2, [H2,H|T]).

get_hidden_layers(0, Hidden_List, []).
get_hidden_layers(Num_Hidden_Layers, Hidden_List, [Hidden_List | Hidden_Layers]) :- 
	Num_Hidden_Layers2 is Num_Hidden_Layers - 1,
	get_hidden_layers(Num_Hidden_Layers2, Hidden_List, Hidden_Layers).	
