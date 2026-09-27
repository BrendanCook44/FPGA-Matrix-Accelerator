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
    
    // Bit Width Test
    task test_bit_width();

        for (int i = 0; i < N; i++) begin
            for (int j = 0; j < N; j++) begin
                dut.matrixA[i][j] = -128;
                dut.matrixB[i][j] = -128;
            end
        end
       
       wait (dut.state == TRANSMITTING_MATRIX);
       @(posedge clk);
       
        for (int i = 0; i < N; i++) begin
            for (int j = 0; j < N; j++) begin
                assert (dut.matrixC[i][j] == 131072)
                    else $error("C[%0d][%0d] = %0d, expected 131072", i, j, dut.matrixC[i][j]);
            end
        end
       
       $display("End of Bit Width Test");
       $finish;
       
    endtask
    
    // Randomly Populate Matrices
    task populate_matrices_randomly();
            for (int i = 0; i < N; i++) begin
                for (int j = 0; j < N; j++) begin
                    dut.matrixA[i][j] = $urandom();
                    dut.matrixB[i][j] = $urandom();
                end
            end
       
       wait (dut.state == TRANSMITTING_MATRIX);
       
       $display("Successfully Generated Matrix Values");
       $finish;
       
    endtask
    
    initial begin
        $display("Start of Matrix Accelerator Module Simulation");
        
        test_bit_width();

    end
    
endmodule
