`timescale 1ns / 1ps

module matrix_accelerator_tb;

    logic clk = 0;
    logic [7:0] data_to_send;
    logic tx_start;
    logic tx_line;
    logic tx_ready;
    localparam N = 8;

    matrix_accelerator #(.N(N)) dut (
        .clk(clk),
        .data_to_send(data_to_send),
        .tx_start(tx_start),
        .tx_line(tx_line),
        .tx_ready(tx_ready)
    );
    
    // Initial Simulation Setup
    always #5 clk = ~clk;
    
    initial begin
        $display("Start of Matrix Accelerator Simulation");
        
        // Fill Matrix A and B
        

        
    end
    
endmodule
