`timescale 1ns / 1ps

module matrix_accelerator_top #(
    parameter CLKS_PER_BIT = 868,
    parameter N = 8
)(
    // External Wires (Mapped To Hardware Via XDC File)
    input wire RsRx,
    output wire RsTx,
    input wire clk
    );

    // Internal Wires
    wire [7:0] rx_byte;
    wire data_valid;
    wire [7:0] echo_byte;
    wire tx_start;
    wire tx_ready;

    uart_rx # (.CLKS_PER_BIT(CLKS_PER_BIT)) u_rx(
        .clk(clk),
        .rx_line(RsRx),
        .data_out(rx_byte),
        .data_valid(data_valid)
    );
    
    matrix_accelerator # (.N(N)) u_matrix_accelerator(
        .clk(clk),
        .data_in(rx_byte),
        .data_valid(data_valid),
        .tx_ready(tx_ready),
        .data_out(echo_byte),
        .tx_start(tx_start)
    );
    
    uart_tx # (.CLKS_PER_BIT(CLKS_PER_BIT)) u_tx(
        .clk(clk),
        .data_to_send(echo_byte),
        .tx_start(tx_start),
        .tx_ready(tx_ready),
        .tx_line(RsTx)
    );

endmodule