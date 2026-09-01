`timescale 1ns / 1ps

module uart_tx_tb;

    logic clk = 0;
    logic [7:0] data_to_send;
    logic tx_start;
    logic tx_line;
    logic tx_ready;
    localparam CLKS_PER_BIT = 4;

    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) dut (
        .clk(clk),
        .data_to_send(data_to_send),
        .tx_start(tx_start),
        .tx_line(tx_line),
        .tx_ready(tx_ready)
    );
    
    // Initial Simulation Setup
    always #5 clk = ~clk;
    
    initial begin
        $display("Start of UART TX Simulation");
        
        $monitor("Time = %0d, Data Sent Through TX Line = %b", $time, tx_line);
        
        data_to_send = 8'b10101010;
        
        tx_start = 1'b1;
        
        #10
        
        tx_start = 1'b0;
        
        #450
        
        tx_start = 1'b1;
        
        # 10
        
        tx_start = 1'b0;
        
    end
    
endmodule
