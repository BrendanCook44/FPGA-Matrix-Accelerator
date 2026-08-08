`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2026 09:59:27 PM
// Design Name: 
// Module Name: echo_core
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


module echo_core(
    input wire clk,
    input wire [7:0] data_in,
    input wire data_valid,
    output reg [7:0] data_out = 0,
    output reg tx_start = 0,
    input wire tx_ready
    );
    
    // Body: Internal Declarations
    
   always @ (posedge clk) begin
        if (data_valid && tx_ready) begin
            data_out <= data_in + 1;
            tx_start <= 1;        
        end
        else begin
        // Reset start signal
        tx_start <= 0;
        end
   end

endmodule
