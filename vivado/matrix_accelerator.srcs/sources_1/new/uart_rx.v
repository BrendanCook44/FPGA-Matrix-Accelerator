`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2026 10:23:09 PM
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx #(
    parameter CLKS_PER_BIT = 868
)(
    input clk,
    input rx_line,
    output [7:0] data_out,
    output data_valid
    );
    
    // Body: Internal Declarations
    reg [$clog2(CLKS_PER_BIT)-1:0] counter;
    
    
    
    
    
    

endmodule
