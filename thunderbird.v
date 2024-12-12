module thunderbird (
    input clk, 
    input rst, 
    input enable, 
    input isleft,
    output reg [2:0] output_state
);

    // State Encoding
    parameter OFF   = 3'b000;
    parameter LEFT1 = 3'b001;
    parameter LEFT2 = 3'b011;
    parameter LEFT3 = 3'b111;
    parameter RIGHT1 = 3'b100;
    parameter RIGHT2 = 3'b110;

    reg [2:0] state, next_state;

    // State Register (Sequential Logic)
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next State Logic (Combinational Logic)
    always @(*) begin
        case (state)
            OFF: 
                if (enable) 
                    next_state = isleft ? LEFT1 : RIGHT1;
                else 
                    next_state = OFF;
            LEFT1: 
                if (enable) 
                    next_state = LEFT2;
                else 
                    next_state = OFF;
            LEFT2: 
                if (enable) 
                    next_state = LEFT3;
                else 
                    next_state = OFF;
            LEFT3: 
                if (enable) 
                    next_state = OFF;
                else 
                    next_state = OFF;
            RIGHT1: 
                if (enable) 
                    next_state = RIGHT2;
                else 
                    next_state = OFF;
            RIGHT2: 
                if (enable) 
                    next_state = LEFT3; // Loop back to LEFT3
                else 
                    next_state = OFF;
            default: 
                next_state = OFF;
        endcase
    end

    // Output Logic (Combinational Logic)
    always @(*) begin
        output_state = state;
    end

endmodule
