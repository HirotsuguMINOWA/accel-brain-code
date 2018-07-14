# -*- coding: utf-8 -*-
import numpy as np
cimport numpy as np
from pydbm.dbm.interface.rt_rbm_builder import RTRBMBuilder
from pydbm.synapse.recurrenttemporalgraph.lstm_graph import LSTMGraph
from pydbm.dbm.restrictedboltzmannmachines.rtrbm.lstm_rt_rbm import LSTMRTRBM
from pydbm.activation.logistic_function import LogisticFunction


class LSTMRTRBMSimpleBuilder(RTRBMBuilder):
    '''
    `Concrete Builder` in Builder Pattern.

    Compose restricted boltzmann machines for building a LSTM-RTRBM.

    '''
    # The list of neurons in visible layer.
    __visible_neuron_count = 10
    # the list of neurons in hidden layer.
    __hidden_neuron_count = 10
    # Complete bipartite graph
    __graph_list = []
    # The list of restricted boltzmann machines.
    __rbm_list = []
    # Learning rate.
    __learning_rate = 0.5

    def get_learning_rate(self):
        ''' getter '''
        if isinstance(self.__learning_rate, float) is False:
            raise TypeError()
        return self.__learning_rate

    def set_learning_rate(self, value):
        ''' setter '''
        if isinstance(value, float) is False:
            raise TypeError()
        self.__learning_rate = value

    learning_rate = property(get_learning_rate, set_learning_rate)

    # Dropout rate.
    __dropout_rate = 0.5

    def get_dropout_rate(self):
        ''' getter '''
        if isinstance(self.__dropout_rate, float) is False:
            raise TypeError()
        return self.__dropout_rate

    def set_dropout_rate(self, value):
        ''' setter '''
        if isinstance(value, float) is False:
            raise TypeError()
        self.__dropout_rate = value

    dropout_rate = property(get_dropout_rate, set_dropout_rate)

    def visible_neuron_part(self, activating_function, int neuron_count):
        '''
        Build neurons in visible layer.

        Args:
            activating_function:    Activation function.
            neuron_count:           The number of neurons.
        '''
        self.__visible_activating_function = activating_function
        self.__visible_neuron_count = neuron_count

    def hidden_neuron_part(self, activating_function, int neuron_count):
        '''
        Build neurons in hidden layer.

        Args:
            activating_function:    Activation function
            neuron_count:           The number of neurons.
        '''
        self.__hidden_activating_function = activating_function
        self.__hidden_neuron_count = neuron_count

    def rnn_neuron_part(self, rnn_activating_function):
        '''
        Build neurons for RNN.

        Args:
            rnn_activating_function:    Activation function
        '''
        self.__rnn_activating_function = rnn_activating_function

    def graph_part(self, approximate_interface):
        '''
        Build RNNRBM graph.

        Args:
            approximate_interface:       The function approximation.
        '''
        self.__approximate_interface = approximate_interface

        self.__lstm_graph = LSTMGraph()
        self.__lstm_graph.observed_activating_function = self.__visible_activating_function
        self.__lstm_graph.input_gate_activating_function = LogisticFunction()
        self.__lstm_graph.hidden_activating_function = self.__rnn_activating_function
        self.__lstm_graph.forget_gate_activating_function = self.__rnn_activating_function
        self.__lstm_graph.output_activating_function = self.__rnn_activating_function
        self.__lstm_graph.rnn_activating_function = self.__rnn_activating_function
        self.__lstm_graph.output_gate_activating_function = self.__hidden_activating_function

        self.__lstm_graph.create_rnn_cells(
            input_neuron_count=self.__visible_neuron_count,
            hidden_neuron_count=self.__hidden_neuron_count,
            output_neuron_count=self.__visible_neuron_count
        )
        self.__lstm_graph.create_node(
            self.__visible_neuron_count,
            self.__hidden_neuron_count,
            self.__visible_activating_function,
            self.__hidden_activating_function
        )

    def get_result(self):
        '''
        Return builded restricted boltzmann machines.

        Returns:
            The list of restricted boltzmann machines.

        '''
        rbm = LSTMRTRBM(
            self.__lstm_graph,
            self.__learning_rate,
            self.__dropout_rate,
            self.__approximate_interface
        )
        return rbm
