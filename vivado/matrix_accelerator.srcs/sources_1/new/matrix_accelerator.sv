`timescale 1ns / 1ps

// FSM - Matrix Accelerator:
// 1 - Populate A Matrix (Row Major Order) - First 64 Bytes from UART RX
// 2 - Populate B Matrix (Row Major Order) - Next 64 Bytes from UART RX
// 3 - Compute C Matrix
// 4 - Send C Matrix 192 Bytes Out To UART TX
// 5 - Set state to RECEIVING_DATA

// i - Which row/line - changing it moves up or down
// j - Which column -  how far along the line - changing it moves left or right

module matrix_accelerator #(
    parameter N = 8
)(
    input logic clk,
    input logic [7:0] data_in,
    input logic data_valid,
    output logic [7:0] data_out = 0,
    output logic tx_start = 0,
    input logic tx_ready
    );
    
    // Package Imports
    import matrix_accelerator_pkg::*;
    
    // Internal Module Declarations

    // i, j, k matrix location counters
    logic [3:0] i = 0;
    logic [3:0] j = 0;
    logic [3:0] k = 0;
    
    // When sending a 20 bit output matrix element out via UART TX, keep track of which segment of bytes have to be sent out
    // 0 (0 - 7)
    // 1 (8 - 15)
    // 2 (16 - 19)
    logic [2:0] byteIndex = 0;
    logic [7:0] tx_byte;
    
    // Matrix A
    logic signed [7:0] matrixA [0:7][0:7];
    
    // Matrix B
    logic signed [7:0] matrixB [0:7][0:7];
    
    // Output Matrix C
    logic signed [19:0] matrixC [0:7][0:7];
    
    // State
    state_t state = RECEIVING_DATA;
    matrix_selection_t matrix_select = MATRIX_A;

    // Accumulator    
    logic signed [19:0] accumulator = 0;
    
    always_comb begin
        case (byteIndex)
            0:       tx_byte = matrixC[i][j][7:0];
            1:       tx_byte = matrixC[i][j][15:8];
            default: tx_byte = {{4{matrixC[i][j][19]}}, matrixC[i][j][19:16]};
        endcase
    end
    
    always_ff @ (posedge clk) begin
    
        if (tx_start) begin
            tx_start <= 0;
        end
        
        if (state == RECEIVING_DATA && data_valid) begin
            // Listen for N * N * 2 Bytes to Populate Matrices A and B
            if (i == N-1 && j == N-1) begin
                i <= 0;
                j <= 0;
            
                if (matrix_select == MATRIX_A) begin
                    matrixA[i][j] <= data_in;
                    matrix_select <= MATRIX_B;
                end
                
                else begin
                    matrixB[i][j] <= data_in;
                    matrix_select <= MATRIX_A;
                    state <= COMPUTING_MATRIX;
                end
            end
            
            else if (i < N-1 && j == N-1) begin
                 i <= i + 1;
                 j <= 0;
                 
                if (matrix_select == MATRIX_A) begin
                    matrixA[i][j] <= data_in;
                end
                
                else begin
                    matrixB[i][j] <= data_in;
                end
            end
            
            else begin
                j <= j + 1;
                
                if (matrix_select == MATRIX_A) begin
                    matrixA[i][j] <= data_in;
                end
                
                else begin
                    matrixB[i][j] <= data_in;
                end
            end
        end
    
        else if (state == COMPUTING_MATRIX) begin
            if (i == N-1 && j == N-1 && k == N-1) begin
                i <= 0;
                j <= 0;
                k <= 0;
                matrixC[i][j] <= (matrixA[i][k] * matrixB[k][j]) + accumulator;
                accumulator <= 0;
                state <= TRANSMITTING_MATRIX;
            end
            
            else if (k == N-1 && j == N-1) begin
                i <= i + 1;
                j <= 0;
                k <= 0;
                matrixC[i][j] <= (matrixA[i][k] * matrixB[k][j]) + accumulator;
                accumulator <= 0;
            end
            
            else if (k == N-1 && j < N-1) begin
                 j <= j + 1;
                 k <= 0;
                 matrixC[i][j] <= (matrixA[i][k] * matrixB[k][j]) + accumulator;
                 accumulator <= 0;
            end
            
            else begin
                accumulator <= accumulator + (matrixA[i][k] * matrixB[k][j]);
                k <= k + 1;
            end
        end

        else if (state == TRANSMITTING_MATRIX) begin
            // Send Matrix C via UART TX in Row Major Order
            // Don't modify i and j until all bytes for an output element are sent out
            if (i == N-1 && j == N-1 && tx_ready && !tx_start) begin
                data_out <= tx_byte;
                tx_start <= 1;
                
                if (byteIndex == 2) begin
                    byteIndex <= 0;
                    i <= 0;
                    j <= 0;
                    state <= RECEIVING_DATA;
                end
                
                else begin
                    byteIndex <= byteIndex + 1;
                end
            end
            
            else if (i < N-1 && j == N-1 && tx_ready && !tx_start) begin
                data_out <= tx_byte;
                tx_start <= 1;
                
                if (byteIndex == 2) begin
                    byteIndex <= 0;
                    i <= i + 1;
                    j <= 0;
                end
                
                else begin
                    byteIndex <= byteIndex + 1;
                end
            end
            
            else begin
                if (tx_ready && !tx_start) begin
                    data_out <= tx_byte;
                    tx_start <= 1;
                    
                    if (byteIndex == 2) begin
                        byteIndex <= 0;
                        j <= j + 1;
                    end
                
                    else begin
                        byteIndex <= byteIndex + 1;
                    end
                end
            end
        end
   end
endmodule