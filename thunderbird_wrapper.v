module thunderbird_wrapper (
    input CLK,                // Clock input
    input [2:0] SW,           // Packed array for switches
    output [5:0] LEDR         // Packed array for LEDs
);
    wire clk = CLK;
    wire rst = SW[0];         // Reset signal from SW[0]
    wire enable_left, enable_right;
	 wire is_left,is_right;
    wire clk_en;              // Output from clk_div, toggles every second
	
    // Instantiate clk_div module to generate enable signals
    clk_div clock_divider (
        .clk(clk),
        .rst(rst),
        .clk_en(clk_en)       // This will toggle every second
    );

    // Conditions to activate left or right modules based on switches and clk_div output
    assign enable_left = SW[2]  ; // Enable left when SW[2] is on and clk_en is active
    assign enable_right = SW[1] ;  // Enable right when SW[1] is on and clk_en is active
	 assign is_left=1;
	 assign is_right=0;
    wire [2:0] output_left, output_right;

    // Instantiate the Left Thunderbird Module
    thunderbird left_module (
        .clk(clk_en),
        .rst(rst),
		  .isleft(is_left),
        .enable(enable_left),
        .output_state(output_left)
    );

    // Instantiate the Right Thunderbird Module
    thunderbird right_module (
        .clk(clk_en),
        .rst(rst),
		  .isleft(is_right),
        .enable(enable_right),
        .output_state(output_right),
    );

    // Map FSM outputs to LEDs
    assign LEDR[5:3] = output_left;   // Map left states to LEDR[5:3]
    assign LEDR[2:0] = output_right;  // Map right states to LEDR[2:0]

endmodule
