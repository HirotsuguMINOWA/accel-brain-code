# -*- coding: utf-8 -*-
import numpy as np
cimport numpy as np
import warnings
from pydbm.dbm.restricted_boltzmann_machines import RestrictedBoltzmannMachine
ctypedef np.float64_t DOUBLE_t


class RTRBM(RestrictedBoltzmannMachine):
    '''
    Reccurent temploral restricted boltzmann machine.
    '''

    def learn(
        self,
        np.ndarray[DOUBLE_t, ndim=2] observed_data_arr,
        int traning_count=-1,
        int batch_size=200,
        int training_count=1000
    ):
        '''
        Learning.

        Args:
            observed_data_arr:    The `np.ndarray` of observed data points.
            traning_count:        Training counts.
            batch_size:           Batch size.
        '''
        if traning_count != -1:
            training_count = traning_count
            warnings.warn("`traning_count` will be removed in future version. Use `training_count`.", FutureWarning)

        cdef int i
        cdef int j
        cdef int row_j
        cdef np.ndarray[DOUBLE_t, ndim=2] data_arr

        # Learning.
        for i in range(batch_size):
            data_arr = observed_data_arr[i:, :]
            row_j = data_arr.shape[0]
            for j in range(row_j):
                self.approximate_learning(
                    data_arr[j],
                    training_count=training_count, 
                    batch_size=batch_size
                )
    
    def inference(
        self,
        np.ndarray[DOUBLE_t, ndim=2] observed_data_arr,
        int traning_count=-1,
        int r_batch_size=200,
        int training_count=1000
    ):
        '''
        Inferencing.
        
        Args:
            observed_data_arr:    The `np.ndarray` of observed data points.
            r_batch_size:         Batch size.
        
        Returns:
            The `np.ndarray` of feature points.
        '''
        if traning_count != -1:
            training_count = traning_count
            warnings.warn("`traning_count` will be removed in future version. Use `training_count`.", FutureWarning)

        cdef int i
        cdef int j
        cdef int row_i
        cdef int row_j
        cdef np.ndarray[DOUBLE_t, ndim=2] data_arr
        cdef np.ndarray[DOUBLE_t, ndim=1] test_arr
        cdef np.ndarray[DOUBLE_t, ndim=2] result_arr
        row_i = observed_data_arr.shape[0]
        result_arr_list = []
        if r_batch_size > 0:
            for i in range(r_batch_size, row_i):
                data_arr = observed_data_arr[i-r_batch_size:i, :]
                row_j = data_arr.shape[0]
                for j in range(row_j):
                    # Execute recursive learning.
                    self.approximate_inferencing(
                        data_arr[j],
                        training_count=training_count, 
                        r_batch_size=r_batch_size
                    )
                # The feature points can be observed data points.
                test_arr = self.graph.visible_activity_arr
                result_arr_list.append(test_arr)
        else:
            data_arr = observed_data_arr
            row_j = data_arr.shape[0]
            for j in range(row_j):
                # Execute recursive learning.
                self.approximate_inferencing(
                    data_arr[j],
                    training_count=training_count, 
                    r_batch_size=r_batch_size
                )
                # The feature points can be observed data points.
                test_arr = self.graph.visible_activity_arr
                result_arr_list.append(test_arr)

        if len(result_arr_list):
            result_arr = np.array(result_arr_list)
            return result_arr
        else:
            return np.array([])
