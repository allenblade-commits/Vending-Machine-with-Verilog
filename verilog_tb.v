module vending_machine_tb;

// ----------------------------
// Inputs
// ----------------------------
reg clk;          // Clock signal
reg [1:0] in;     // Coin input: 01 = Rs 5, 10 = Rs 10
reg rst;          // Reset

// ----------------------------
// Outputs
// ----------------------------
wire out;         // Bottle output
wire [1:0] change; // Change output

// ----------------------------
// Instantiate DUT (Device Under Test)
// ----------------------------
vending_machine_18105070 uut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out),
    .change(change)
);

// ----------------------------
// Testbench stimulus
// ----------------------------
initial begin
    // Create VCD waveform file
    $dumpfile("vending_machine_18105070.vcd");
    $dumpvars(0, vending_machine_tb);

    // Initialize signals
    rst = 1;       // Start with reset active
    clk = 0;
    in = 0;

    // Release reset after some time
    #6 rst = 0;

    // INSERT Rs 10 (in = 2 = 2'b10)
    in = 2;        // First coin Rs 10
    #19;

    // INSERT Rs 10 again → total Rs 20
    // Should dispense bottle + Rs 5 change
    in = 2;        // Second coin Rs 10
    #25;

    // Finish simulation
    $finish;
end

// ----------------------------
// Clock generation: 10 time units period
// ----------------------------
always #5 clk = ~clk;

endmodule
