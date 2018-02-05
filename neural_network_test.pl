% Unit tests for the neural network class %
:- ensure_loaded('neural_network.pl').

test :- test_get_list.

test_get_list :- get_list(10, List), length(List, 10), get_list(2, List2), length(List2, 2), get_list(0, List3), length(List3, 0).

