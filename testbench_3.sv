// Code your testbench here
// or browse Examples
`timescale 1ns/1ns

module SystolicArray2x2_tb();

    parameter DATA_WIDTH = 4;
    parameter ACC_WIDTH  = 9;
    parameter LSIZE      = 2;
    parameter RSIZE      = 2;

    // Inputs 
    reg clk;
    reg rstn;
    reg in_valid;
    reg [DATA_WIDTH-1:0] a00, a01, a10, a11;
    reg [DATA_WIDTH-1:0] b00, b01, b10, b11;

    // Outputs
    wire out_valid;
    wire [ACC_WIDTH-1:0] c00, c01, c10, c11;

    initial begin
        $display("Systolic Array 2x2 TB");

      	$dumpfile("SystolicArray2x2.vcd");
        $dumpvars();

        // Initialize inputs
        clk      = 0;
        rstn     = 0;
        in_valid = 0;
        a00 = 4'b0000; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b0000;
        b00 = 4'b0000; b01 = 4'b0000; b10 = 4'b0000; b11 = 4'b0000;

        // Wait for global reset
        #95;
        rstn = 1;

        // 0th clock cycle
        // Start shift weights in - 1st set
        #10;
        a00 = 4'b0000; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b0000;
        b00 = 4'b0000; b01 = 4'b1011; b10 = 4'b0000; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 0", c00, c01, c10, c11);

        // 1st clock cycle
        #10;
        a00 = 4'b0000; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b0000;
        b00 = 4'b0111; b01 = 4'b0000; b10 = 4'b0010; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 1", c00, c01, c10, c11);

        // 2nd clock cycle
        // Shift last weight in   - 1st set
        // Start shift data in    - 1st set
        // Start shift weights in - 2nd set
        #10;
        in_valid = 1;
        a00 = 4'b0101; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b0000;
        b00 = 4'b0000; b01 = 4'b0010; b10 = 4'b0000; b11 = 4'b1001;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 2", c00, c01, c10, c11);

        // 3rd clock cycle
        #10;
        a00 = 4'b0000; a01 = 4'b0101; a10 = 4'b1111; a11 = 4'b0000;
        b00 = 4'b0001; b01 = 4'b0000; b10 = 4'b1010; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 3", c00, c01, c10, c11);  

        // 4th clock cycle
        // Shift last data in     - 1st set
        // Shift last weight in   - 2nd set
        // Start shift data in    - 2nd set
        // Start shift weights in - 3rd set
        #10;
        a00 = 4'b1010; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b1110;
        b00 = 4'b0000; b01 = 4'b1100; b10 = 4'b0000; b11 = 4'b1000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 4", c00, c01, c10, c11);

        // 5th clock cycle
        #10;
        a00 = 4'b0000; a01 = 4'b1001; a10 = 4'b0101; a11 = 4'b0000;
        b00 = 4'b0011; b01 = 4'b0000; b10 = 4'b0110; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 5", c00, c01, c10, c11);

        // 6th clock cycle
        // Check output of 1st set
        // Shift last data in   - 2nd set
        // Shift last weight in - 3rd set
        // Start shift data in  - 3rd set
        #10;
        a00 = 4'b0010; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b0101;
        b00 = 4'b0000; b01 = 4'b0000; b10 = 4'b0000; b11 = 4'b0100;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 6", c00, c01, c10, c11);

        // 7th clock cycle
        #10;
        a00 = 4'b0000; a01 = 4'b1011; a10 = 4'b1101; a11 = 4'b0000;
        b00 = 4'b0000; b01 = 4'b0000; b10 = 4'b0000; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 7", c00, c01, c10, c11);

        // 8th clock cycle
        // Check output of 2nd set
        // Shift last data in - 3rd set
        #10;
        a00 = 4'b0000; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b1101;
        b00 = 4'b0000; b01 = 4'b0000; b10 = 4'b0000; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 8", c00, c01, c10, c11);

        // 9th clock cycle
        #10;
        a00 = 4'b0000; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b0000;
        b00 = 4'b0000; b01 = 4'b0000; b10 = 4'b0000; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 9", c00, c01, c10, c11);

        // 10th clock cycle
        // Check output of 3rd set
        #10;
        in_valid = 0;
        a00 = 4'b0000; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b0000;
        b00 = 4'b0000; b01 = 4'b0000; b10 = 4'b0000; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 10", c00, c01, c10, c11);   

        // 11th clock cycle
        #10;
        a00 = 4'b0000; a01 = 4'b0000; a10 = 4'b0000; a11 = 4'b0000;
        b00 = 4'b0000; b01 = 4'b0000; b10 = 4'b0000; b11 = 4'b0000;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 11", c00, c01, c10, c11);

        // Finish simulation
        #200;
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk; // 100MHz clock
    end

    // Instantiate DUT
    SystolicArray2x2 #(DATA_WIDTH, ACC_WIDTH, LSIZE, RSIZE) u_2x2dut(
        .clk(clk),
        .rstn(rstn),
        .in_valid(in_valid),
        .a00(a00), .a01(a01), .a10(a10), .a11(a11),
        .b00(b00), .b01(b01), .b10(b10), .b11(b11),
        .out_valid(out_valid),
        .c00(c00), .c01(c01), .c10(c10), .c11(c11)
    );
endmodule