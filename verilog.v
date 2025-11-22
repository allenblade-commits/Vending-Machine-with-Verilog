module vending_machine_18105070(
    input clk,              // System clock
    input rst,              // Synchronous reset
    input [1:0] in,         // Input coin: 01 = Rs 5, 10 = Rs 10
    output reg out,         // 1 = dispense bottle
    output reg [1:0] change // Change returned: 01 = Rs 5, 10 = Rs 10
);

parameter s0 = 2'b00;       // State s0: total = Rs 0
parameter s1 = 2'b01;       // State s1: total = Rs 5
parameter s2 = 2'b10;       // State s2: total = Rs 10

reg [1:0] c_state, n_state; // Current state and next state registers

// Sequential block (state transition on clock edge)
always @ (posedge clk) 
begin
    if (rst == 1) begin
        // Reset all states and outputs
        c_state = s0;
        n_state = s0;
        change = 2'b00;
        out = 0;
    end 
    else begin
        // Update current state
        c_state = n_state;
    end

    // FSM: Next state logic and output logic
    case (c_state)

        // ---------------------------------------------------------
        // STATE S0 : Total inserted = 0
        // ---------------------------------------------------------
        s0:
            if (in == 0) begin
                n_state = s0;
                out = 0;
                change = 2'b00;   // No coin, no change
            end
            else if (in == 2'b01) begin
                n_state = s1;
                out = 0;
                change = 2'b00;   // Rs 5 inserted
            end
            else if (in == 2'b10) begin
                n_state = s2;
                out = 0;
                change = 2'b00;   // Rs 10 inserted
            end

        // ---------------------------------------------------------
        // STATE S1 : Total inserted = Rs 5
        // ---------------------------------------------------------
        s1:
            if (in == 0) begin
                n_state = s0;
                out = 0;
                change = 2'b01;   // Return Rs 5
            end
            else if (in == 2'b01) begin
                n_state = s2;
                out = 0;
                change = 2'b00;   // Rs 5 + Rs 5 = Rs 10
            end
            else if (in == 2'b10) begin
                n_state = s0;
                out = 1;          // Rs 5 + Rs 10 = Rs 15 → dispense bottle (cost Rs 15)
                change = 2'b00;   // No change
            end

        // ---------------------------------------------------------
        // STATE S2 : Total inserted = Rs 10
        // ---------------------------------------------------------
        s2:
            if (in == 0) begin
                n_state = s0;
                out = 0;
                change = 2'b10;   // Return Rs 10
            end
            else if (in == 2'b01) begin
                n_state = s0;
                out = 1;          // Rs 10 + Rs 5 = Rs 15 → dispense bottle
                change = 2'b00;
            end
            else if (in == 2'b10) begin
                n_state = s0;
                out = 1;          // Rs 10 + Rs 10 = Rs 20 → bottle + Rs 5 change
                change = 2'b01;   // Return Rs 5
            end

    endcase
end

endmodule
