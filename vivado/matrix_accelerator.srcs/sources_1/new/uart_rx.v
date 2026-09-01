`timescale 1ns / 1ps

module uart_rx #(
    parameter CLKS_PER_BIT = 868
)(
    input wire clk,
    input wire rx_line,
    output reg [7:0] data_out,
    output reg data_valid = 0
    );
    
    localparam IDLE = 0;
    localparam INITIAL_CHECK = 1;
    localparam RECEIVING = 2;
    
    // Body: Internal Declarations
    reg [$clog2(CLKS_PER_BIT)-1:0] counter;
    reg [3:0] bit_index = 0;
    reg [1:0] state = IDLE;
    reg prev_edge = 1;
    reg clockDomainSync1 = 1;
    reg clockDomainSync2 = 1;
    
    always @ (posedge clk) begin
        // Sync boundary between FTDI Chip & FPGA CLK
        clockDomainSync1 <= rx_line;
        clockDomainSync2 <= clockDomainSync1;
        prev_edge <= clockDomainSync2;
        
        // Check if Data Valid was triggered last pulse and reset to 0
        if (data_valid == 1) begin
            data_valid <= 0;
        end
        
        // Trigger RX - Look for falling edge between clock domain sync and previous edge
        if (clockDomainSync2 == 0 && prev_edge == 1 && state == IDLE) begin
            counter <= 0;
            bit_index <= 0;
            data_valid <= 0;
            state <= INITIAL_CHECK;
        end
        // Check first bit at half of CLKS_PER_BIT for best sampling reliability
        else if (counter == ((CLKS_PER_BIT - 1) / 2) && state == INITIAL_CHECK) begin
           if (clockDomainSync2 == 0) begin
            state <= RECEIVING;
            counter <= 0;
           end
           
           else begin
            state <= IDLE;
           end
        end
        // Counter hasn't reached CLKS_PER_BIT yet, increase counter
        else if (counter < CLKS_PER_BIT - 1 && state == RECEIVING || state == INITIAL_CHECK) begin
            counter <= counter + 1;
        end
        // Counter has reached CLKS_PER_BIT, listen to whatever value is on RX_LINE and assign to data_out
        // Once the byte is assembled, trigger data_valid
        else if (counter == CLKS_PER_BIT - 1 && state == RECEIVING) begin
            if (bit_index == 8) begin
                state <= IDLE;
                bit_index <= 0;
                counter <= 0;
                data_valid <= 1;
            end
            else begin
                data_out[bit_index] <= clockDomainSync2;
                bit_index <= bit_index + 1;
                counter <= 0;
            end
        end
    end
endmodule
