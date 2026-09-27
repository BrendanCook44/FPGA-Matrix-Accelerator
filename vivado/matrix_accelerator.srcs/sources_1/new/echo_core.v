`timescale 1ns / 1ps

// FSM - UART Echo:
// 1 - Receive a byte via UART RX Module
// 2 - Add +1 to received byte
// 3 - Transmit modified +1 byte out via UART TX Module

module echo_core(
    input wire clk,
    input wire [7:0] data_in,
    input wire data_valid,
    output reg [7:0] data_out = 0,
    output reg tx_start = 0,
    input wire tx_ready
    );
    
    // Internal Module Declarations
    
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
