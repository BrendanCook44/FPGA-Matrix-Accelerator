`timescale 1ns / 1ps

module matrix_accelerator_tb;

    logic clk = 0;
    logic [7:0] data_in;
    logic data_valid = 0;
    logic [7:0] data_out;
    logic tx_start;
    logic tx_ready = 1;
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
    
    // Matrix A & Matrix B Copies To Compare Testbench Results Against
    logic signed [7:0] matrixA [0:7][0:7];
    logic signed [7:0] matrixB [0:7][0:7];
   
    // Fill Matrix A & Matrix B values
    task automatic send_matrix_bytes();
       
        // Send matrix values
        for (int idx = 0; idx < 2 * N * N; idx++) begin
            @ (negedge clk);
            // assign random values to module
            data_in = $urandom();
            data_valid = 1;
            
            if (idx < N * N) begin
                // calculate the rows and columns by determining how many rows and columns came before it
                int rows = idx / N;
                int cols = idx % N;
                matrixA[rows][cols] = data_in;

            end
            
            else begin
                int rows = (idx - N * N) / N;
                int cols = (idx - N * N) % N;
                matrixB[rows][cols] = data_in;
            end

            @ (negedge clk);
            data_valid = 0;
        end
        
        @ (posedge clk);
        assert (dut.state == COMPUTING_MATRIX)
            else $error("Load did not complete, state = %s", dut.state.name());
       
       $display("Successfully Generated Matrix Values");
       
    endtask
    
    initial begin
        $display("Start of Matrix Accelerator Module Simulation");
        
        send_matrix_bytes();
        
        
        
        $finish;

    end
    
endmodule
