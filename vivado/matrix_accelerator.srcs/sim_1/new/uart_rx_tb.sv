`timescale 1ns / 1ps

module uart_rx_tb;

    logic clk = 0;
    logic rx_line;
    logic [7:0] data_out;
    logic data_valid;
    localparam CLKS_PER_BIT = 4;

uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) dut (
    .clk(clk),
    .rx_line(rx_line),
    .data_out(data_out),
    .data_valid(data_valid)
);

task send_byte(input [7:0] data);

    // Send Start Bit
    rx_line = 1'b0;
    repeat (CLKS_PER_BIT) @(posedge clk);
    
    // Send 8 Data Bits
    for (int i = 0; i < 8; i++) begin
        rx_line = data[i];
        repeat (CLKS_PER_BIT) @(posedge clk);
    end
    
    // Send Stop Bit
    rx_line = 1'b1;
    repeat (CLKS_PER_BIT) @(posedge clk);
endtask

// Initial Simulation Setup
always #5 clk = ~clk;

initial begin
    $display("Start of UART RX Simulation");
    
    $monitor("Time = %0d, Data Received Through RX Line = %b", $time, data_out);
    $monitor("Data Valid New Value: %b", data_valid);
    
    send_byte(8'hAA);
    send_byte(8'h55);
    
    // @ (posedge data_valid) assert (data_out == 8'hAA) else $error("Expected %h, got %h", 8'hAA, data_out);

end

endmodule
