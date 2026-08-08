`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2026 10:22:20 PM
// Design Name: 
// Module Name: uart_tx
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

module uart_tx #(
    parameter CLKS_PER_BIT = 868
)(
    input wire clk,
    input wire [7:0] data_to_send,
    input wire tx_start,
    output reg tx_line = 1,
    output reg tx_ready = 1
    );
    
    localparam IDLE = 0;
    localparam SENDING = 1;
    
    // Body: Internal Declarations
    reg [$clog2(CLKS_PER_BIT)-1:0] counter;
    reg [3:0] bit_index = 0;
    reg state = IDLE;
    reg [9:0] frame = 0;
    
    always @ (posedge clk) begin
        if (tx_start && tx_ready && state == IDLE) begin
            tx_ready <= 0;
            tx_line <= 0;
            counter <= 0;
            bit_index <= 0;
            state <= SENDING;
            frame <= {1'b1, data_to_send, 1'b0};
        end
        // Counter hasn't reached CLKS_PER_BIT yet, increase counter
        else if (counter < CLKS_PER_BIT - 1 && state == SENDING) begin
            counter <= counter + 1;
        end
        // Counter has reached CLKS_PER_BIT, write out the data at the current bit index from 0-10 until all are written out of tx_line
        else if (counter == CLKS_PER_BIT - 1 && state == SENDING) begin
            if (bit_index == 9) begin
                tx_ready <= 1;
                tx_line <= 1;
                state <= IDLE;
            end
            else begin
                tx_line <= frame[bit_index + 1];
                bit_index <= bit_index + 1;
                counter <= 0;
            end
        end
    end
endmodule
