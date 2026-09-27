`timescale 1ns / 1ps

module matrix_accelerator_tb;

    logic clk = 0;
    logic [7:0] data_in;
    logic data_valid;
    logic [7:0] data_out;
    logic tx_start;
    logic tx_ready;
    localparam N = 8;

    matrix_accelerator #(.N(N)) dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .data_out(data_out),
        .tx_start(tx_start),
        .tx_ready(tx_ready)
    );
    
    // Package Imports
    import matrix_accelerator_pkg::*;
    
    // Initial Simulation Setup
    always #5 clk = ~clk;
    
    initial begin
        $display("Start of Matrix Accelerator Simulation");
        
        // Fill Matrix A and B
        for (int i = 0; i < N; i++) begin
            for (int j = 0; j < N; j++) begin
                dut.matrixA[i][j] = -128;
                
                // dut.matrixA[i][j] = $urandom();
                
                dut.matrixB[i][j] = -128;
                
            end
        end
       
       wait (dut.state == TRANSMITTING_MATRIX);

    end
    
endmodule
