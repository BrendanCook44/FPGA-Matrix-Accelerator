`timescale 1ns / 1ps

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
    
    // FSM:
    // 1 - Load A Matrix - First 64 Bytes from UART RX
    // 2 - Load B Matrix - Next 64 Bytes from UART RX
    // 3 - Compute C Matrix
    // 4 - Stream C Matrix 64 Bytes Out To UART TX
    
    typedef enum logic [1:0] {
        IDLE                = 2'b00,
        RECEIVING_DATA      = 2'b01,
        COMPUTING_MATRIX    = 2'b10,
        TRANSMITTING_MATRIX = 2'b11
    } state_t;
    
    // Body: Internal Declarations

    // i, j, k counters
    logic [3:0] i = 0;
    logic [3:0] j = 0;
    logic [3:0] k = 0;
    
    // Matrix A
    logic signed [7:0] matrixA [0:7][0:7];
    
    // Matrix B
    logic signed [7:0] matrixB [0:7][0:7];
    
    // Output Matrix C
    logic signed [19:0] matrixC [0:7][0:7];
    
    // State
    state_t state = COMPUTING_MATRIX;

    // Accumulator    
    logic signed [19:0] accumulator = 0;
    
    always_ff @ (posedge clk) begin
        
        if (state == RECEIVING_DATA && data_valid) begin
            // Listen for 128 Bytes to Populate Matrices A and B
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
        end
   end

endmodule
    
    
    // Loop through rows
//    for (int i = 0; i < N; i++) begin
    
//        // Loop though columns
//        for (int j = 0; j < N; j++) begin
//                 matrixC[i][j] = 0;
                 
//            // Loop through elements inside rows and columns to multiply and add them up
//            for (int k = 0; k < N; k++) begin
//                matrixC[i][j] = matrixA[i][k] * matrixB[k][j];
                
//            end
//        end
//    end
   
   
   
   
//     Check for 64 Data Valid Signals from UART RX for Matrix A
//     if (counter > 64) begin
//         if (data_valid) begin
//             matrixA[i][j] <= data_in;
//             counter <= counter + 1;
//         end
//     end