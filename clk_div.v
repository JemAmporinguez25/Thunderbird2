module clk_div (
    input clk,      // Input clock signal from the FPGA
    input rst,      // Reset signal to initialize the divider
    output clk_en   // Output enable signal generated at a slower rate
);
    reg [24:0] clk_count; // 25-bit counter to divide the clock frequency

    // Clock counting logic
    always @(posedge clk or posedge rst) begin
        if (rst)               // Reset condition
            clk_count <= 0;    // Reset the counter to zero
        else
            clk_count <= clk_count + 1; // Increment the counter at each clock cycle
    end

    // Generate enable signal (clk_en) when all counter bits are '1'
    assign clk_en = &clk_count; // Bitwise AND of all bits in clk_count

endmodule
