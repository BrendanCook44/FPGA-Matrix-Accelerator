`timescale 1ns / 1ps
`default_nettype none

module uart_echo_top(
    input wire RsRx,
    output wire RsTx,
    input wire clk
    );
    
wire [7:0] rx_byte;
wire data_valid;
wire [7:0] echo_byte;
wire tx_start;
wire tx_ready;

uart_rx u_rx (
    .clk(clk),
    .rx_line(RsRx),
    .data_out(rx_byte),
    .data_valid(data_valid)
);

echo_core application(
    .clk(clk),
    .data_in(rx_byte),
    .data_valid(data_valid),
    .tx_ready(tx_ready),
    .data_out(echo_byte),
    .tx_start(tx_start)
);

uart_tx u_tx (
    .clk(clk),
    .data_to_send(echo_byte),
    .tx_start(tx_start),
    .tx_ready(tx_ready),
    .tx_line(RsTx)
);

endmodule