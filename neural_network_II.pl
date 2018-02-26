:- use_module(library(random)).
%Second attempt, seems simpler than I'm making it... but I could be wrong...

%Okay so we have a neural network
initialize_neural_network(Layers, [Input_Nodes, Hidden_Nodes, Output_Nodes], List) :- 
  %First of all hidden layers is layers-2
  Hidden_Layers is Layers-2,
  %Next we compute number of weights which have three categories:
  %Input_Nodes to Hidden_Nodes
  %Hidden_Nodes to Hidden_Nodes
  %Hidden_Nodes to Output_Nodes
  %Computation occurs like so:
  % [INPUTS] -> multiplied by input to hidden respectively and summed to get [HIDDEN_NODES] L-1
  % [HIDDEN_NODES_I] -> multiplied by hidden to hidden respectively and summed to get the next layer of [HIDDEN_NODES_II]  L-2
  % ... repeated until L-(L-1)
  % [HIDDEN_NODES_(N)] -> multiplied by hidden to output respectively and summed to get the output(s)
  % Looks something like
  % For each hidden node: 
  %   Take the sum of:
  %     For each input: 
  %       multiply input * weight from input to hidden node
  Input_Weights is Input_Nodes*Hidden_Nodes,
  Hidden_Weights is Hidden_Nodes*Hidden_Nodes,
  Output_Weights is Hidden_Nodes*Output_Nodes,
  get_weights(Input_Weights, In_Weights),
  %if there is more than one hidden layer (such that we would need weights between them)
  (Hidden_Layers > 1 ->
  %then get hidden weights
  get_hidden_weights(Hidden_Layers, Hidden_Weights, [], Hid_Weights)
  %else no-op 
  ; Hidden_Layers is 1),
  get_weights(Output_Weights, Out_Weights),
  % if there is more than one hidden layer
  (Hidden_Layers > 1 ->
  add_list(Out_Weights, [], Network),
  add_list(Hid_Weights, Network, New_Network)
  ; add_list(Out_Weights, [], New_Network)),
  add_list(In_Weights, New_Network, List).

%Initialize a list with random weights to a given length
get_weights(0, []).
get_weights(Length, [Rand_Weight | List]) :-
  New_Length is Length-1, 
  random(Rand_Weight),
  get_weights(New_Length, List).

%Take a number of layers (number of lists), and the number of elements in each list and generate a composite list of all the elements
get_hidden_weights(0, _Hidden_Weights, Hid_Weights, Hid_Weights).
get_hidden_weights(Hidden_Layers, Hidden_Weights, Temp_Weights, Hid_Weights) :-
  New_Hidden_Layers is Hidden_Layers-1, 
  get_weights(Hidden_Weights, New_Hid_Weights),
  add_list(New_Hid_Weights,Temp_Weights, New_Temp_Weights),
  get_hidden_weights(New_Hidden_Layers, Hidden_Weights, New_Temp_Weights, Hid_Weights).

add_list(L1, [], [L1]).
add_list(L1, [H|T], [L1,H|T]).


sigmoid_function(Z, Output) :-
  Output is 1 rdiv e, format('~50f~n',[Output]).
