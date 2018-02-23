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
  .
