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
  (Hidden_Layers > 1 ->
  Bias_Weights is (Hidden_Nodes*Hidden_Layers)+Output_Nodes % Bias nodes is the number of hidden nodes (hidden nodes per layer * hidden layers) plus the number of output nodes
  ; Bias_Weights is Hidden_Nodes + Output_Nodes), % Bias nodes is still the number of hidden nodes plus the number of output nodes
  get_weights(Bias_Weights, B_Weights),
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

%Add a list to a list of lists, the inputs are: L1, [H|T] and the output. L1 is the list to add and [H|T] is the accumulator
add_list(L1, [], [L1]).
add_list(L1, [H|T], [L1,H|T]).

%Simply the sigmoid function, this gets the sum of the inputs to a node times their weights
%I found that on my system anything less than -709 was a float overflow. As this corresponds to 1.21678e-308, 
%I concluded that it was probably safe to round that down to zero and -700 is 9.859676e-305, so that seems
%like a good place to round. I'm hoping that this rounding error is acceptable. 
sigmoid_function(Z, Output) :-
  (Z < -700 -> 
  Output is 0
  ;  Output is 1/(1+(e^(-1*Z)))).

%Taking the derivative of a sigmoid function based on the output of the sigmoid function
%Sigmoid: The output of sigmoid_function(Z)
%Output: The derivative of the sigmoid function w.r.t. Z
sigmoid_derivative(Sigmoid, Output) :-
  Output is Sigmoid * (1 - Sigmoid).

%Back propagation, first we have an error function
%Output is a list of the output from the output nodes (FOR NOW JUST ONE)
%Target is a list of the target for the output nodes (FOR NOW JUST ONE)
network_error(Output,Target,Error) :-
  Error is (1/2)*(Output - Target)^2.


%This gives delta from the output node whose Actual_Output and Target are given.
%The use of this is manifold:
%
%
%First the modification of the weight from hidden node i to output node j (w_ij) is
%         delta_j                      *                  output_i
%The delta of the output node        times      The output of the hidden node
%
%
%
%The weight update for the bias from bias node a to output node j (w_aj) is
%         delta_j                      *                   1 (output_b)
%The delta of the output node        times      The output of the bias node (always 1)
%
%
%Then for the next layer of nodes this value is used as well
%The weight update for the hidden or input node h to hidden node i is
%         output_h                     *                  derivative of the activation function of i * the sum of (d_ij * w_ij) for all output nodes j
%The output of the input node        times                             This winds up being the delta_i which is then used in a similar fashion for the next layer.
delta_output_node(Actual_Output, Target, Delta) :- 
  sigmoid_derivative(Actual_Output, Derivative),
  Delta is (Actual_Output-Target)*Derivative. 

%Delta of node J
%Output_J the output of the sigmoid activation function from node J
%Delta_K_List the deltas from the nodes K 
%Weight_J_K_List the weights from this node J to K
delta_node(Output_J, Delta_K_List, Weight_J_K_List, Delta_J)

%All the bias updates are based on the delta of the node 
update_bias_weight(Delta, Learning_Rate, Current_Weight, Updated_Weight) :- 
  Updated_Weight is Current_Weight - (Learning_Rate * Delta).

%Update weight from i to j. Takes the computed delta from j
update_weight(Delta_J, Output_I, Learning_Rate, Current_Weight_IJ, Updated_Weight_IJ) :- 
  Updated_Weight is Current_Weight - (Learning_Rate * Delta_J * Output_I).
  



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Useful but might want to do something more oriented to a list... %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Backpropagation to the weights piped to the output
%Output is the output of the output node, target is the target of the output, previous node output is the output of the hidden layer node whose weight to this output is being updated
%Weight update is the update to the weight from the hidden layer
output_update(Output, Target, Previous_Node_Output, Weight_Update, Delta) :-
  sigmoid_derivative(Output, Derivative),
  Delta is (Output-Target)*Derivative,
  Weight_Update is Delta*Previous_Node_Output. 

%Error due to this node is the sum of all the delta from the output nodes times the weight of this node
%to the relevant output node
hidden_update(Output, Error_Due_To_This_Node, Previous_Node_Output, Weight_Update, Delta) :-
  sigmoid_derivative(Output, Derivative),
  Delta is Derivative*Error_Due_To_This_Node,
  Weight_Update is Previous_Node_Output*Derivative*Error_Due_To_This_Node. 



