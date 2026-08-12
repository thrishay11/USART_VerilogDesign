// USART Transmitter Testbench: Verifies the serial transmission
// of 8-bit data from the USART transmitter.

`timescale 1ns / 1ps

module tb_usart_tx;

    reg clk = 0;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;

    usart_tx uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Reset
        rst = 1;
        tx_start = 0;
        tx_data = 8'hA5;

        #20;
        rst = 0;

        // Start transmission
        #20;
        tx_start = 1;

        #10;
        tx_start = 0;

        // Wait for transmission
        #2000;

        $finish;
    end

endmodule
