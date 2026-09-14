`timescale 1ns / 1ps

module uart_echo_top_tb;

    logic RsRx = 1;
    logic RsTx;
    logic clk = 0;
    logic [7:0] received;
    localparam CLKS_PER_BIT = 4;
    
    uart_echo_top #(.CLKS_PER_BIT(CLKS_PER_BIT)) dut (
        .RsRx(RsRx),
        .RsTx(RsTx),
        .clk(clk)
    );
    
    task send_byte(input [7:0] data);
    
        // Send Start Bit
        RsRx = 1'b0;
        repeat (CLKS_PER_BIT) @(posedge clk);
        
        // Send 8 Data Bits
        for (int i = 0; i < 8; i++) begin
            RsRx = data[i];
            repeat (CLKS_PER_BIT) @(posedge clk);
        end
        
        // Send Stop Bit
        RsRx = 1'b1;
        repeat (CLKS_PER_BIT) @(posedge clk);
    endtask
    
    task receive_byte(output [7:0] data);
    
        // Listen for Start Bit
        @(negedge RsTx)
        repeat (CLKS_PER_BIT / 2) @(posedge clk);
        assert (RsTx == 0);
        
        // Receive 8 Data Bits
        for (int i = 0; i < 8; i++) begin
            repeat (CLKS_PER_BIT) @(posedge clk);
            data[i] = RsTx;
        end
        
        // Receive Stop Bit
        repeat (CLKS_PER_BIT) @(posedge clk);
        assert (RsTx == 1);
    endtask
    
    // Initial Simulation Setup
    always #5 clk = ~clk;
    
    initial begin
    
        $display("Start of UART Echo Application Simulation");
        
        $monitor("Time = %0d, Data Sent Through RX Line = %b", $time, RsRx);
        
        send_byte(8'hAA);
        
        receive_byte(received);
    
        $display("End of UART Echo Application Simulation");   
    
    end
    
endmodule
