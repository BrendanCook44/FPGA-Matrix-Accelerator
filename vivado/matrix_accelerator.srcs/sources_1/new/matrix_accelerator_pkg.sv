`timescale 1ns / 1ps

package matrix_accelerator_pkg;

    
typedef enum logic [1:0] {
    IDLE                = 2'b00,
    RECEIVING_DATA      = 2'b01,
    COMPUTING_MATRIX    = 2'b10,
    TRANSMITTING_MATRIX = 2'b11
} state_t;

endpackage

