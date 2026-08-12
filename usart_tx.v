// USART Transmitter: Converts 8-bit parallel data into serial data
// using start, data, and stop bits with configurable clock-per-bit timing.

module usart_tx (
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);

    parameter CLK_PER_BIT = 16;

    reg [3:0] bit_index = 0;
    reg [7:0] shift_reg = 8'd0;
    reg [3:0] clk_count = 0;
    reg [1:0] state = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            state <= 0;
            bit_index <= 0;
            clk_count <= 0;
        end else begin
            case (state)

                0: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;

                    if (tx_start) begin
                        shift_reg <= tx_data;
                        state <= 1;
                        tx_busy <= 1'b1;
                        clk_count <= 0;
                    end
                end

                1: begin
                    // Start bit
                    tx <= 1'b0;

                    if (clk_count == CLK_PER_BIT - 1) begin
                        clk_count <= 0;
                        state <= 2;
                        bit_index <= 0;
                    end else
                        clk_count <= clk_count + 1;
                end

                2: begin
                    // Data bits
                    tx <= shift_reg[bit_index];

                    if (clk_count == CLK_PER_BIT - 1) begin
                        clk_count <= 0;

                        if (bit_index == 7)
                            state <= 3;
                        else
                            bit_index <= bit_index + 1;
                    end else
                        clk_count <= clk_count + 1;
                end

                3: begin
                    // Stop bit
                    tx <= 1'b1;

                    if (clk_count == CLK_PER_BIT - 1) begin
                        clk_count <= 0;
                        state <= 0;
                        tx_busy <= 1'b0;
                    end else
                        clk_count <= clk_count + 1;
                end

            endcase
        end
    end

endmodule
