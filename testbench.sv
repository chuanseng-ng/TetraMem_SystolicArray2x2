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

        $fsdbDumpfile("SystolicArray2x2,fsdb");
        $fsdbDumpvars(0, SystolicArray2x2_tb);

        // Initialize inputs
        clk      = 0;
        rstn     = 0;
        in_valid = 0;
        a00 = 0, a01 = 0, a10 = 0, a11 = 0;
        b00 = 0, b01 = 0, b10 = 0, b11 = 0;

        // Wait for global reset
        #95;
        rstn = 1;

        // 0th clock cycle
        // Start shift weights in - 1st set
        #10;
        a00 = 0, a01 = 0, a10 = 0, a11 = 0;
        b00 = 0, b01 = 2, b10 = 0, b11 = 0;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 0", c00, c01, c10, c11);

        // 1st clock cycle
        #10;
        a00 = 0, a01 = 0, a10 = 0, a11 = 0;
        b00 = 4, b01 = 0, b10 = 6, b11 = 0;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 1", c00, c01, c10, c11);

        // 2nd clock cycle
        // Shift last weight in   - 1st set
        // Start shift data in    - 1st set
        // Start shift weights in - 2nd set
        #10;
        in_valid = 1;
        a00 = 4, a01 = 0, a10 = 0, a11 = 0;
        b00 = 0, b01 = 4, b10 = 0, b11 = 8;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 2", c00, c01, c10, c11);

        // 3rd clock cycle
        #10;
        a00 = 0, a01 = 3, a10 = 12, a11 = 0;
        b00 = 7, b01 = 0, b10 = 8,  b11 = 0;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 3", c00, c01, c10, c11);  

        // 4th clock cycle
        // Shift last data in     - 1st set
        // Shift last weight in   - 2nd set
        // Start shift data in    - 2nd set
        // Start shift weights in - 3rd set
        #10;
        a00 = 12, a01 = 0, a10 = 0, a11 = 4;
        b00 = 0,  b01 = 1, b10 = 0, b11 = 1;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 4", c00, c01, c10, c11);

        // 5th clock cycle
        #10;
        a00 = 0, a01 = 14, a10 = 10, a11 = 0;
        b00 = 3, b01 = 0,  b10 = 5,  b11 = 0;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 5", c00, c01, c10, c11);

        // 6th clock cycle
        // Check output of 1st set
        // Shift last data in   - 2nd set
        // Shift last weight in - 3rd set
        // Start shift data in  - 3rd set
        #10;
        a00 = 2, a01 = 0, a10 = 0, a11 = 1;
        b00 = 0, b01 = 0, b10 = 0, b11 = 7;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 6", c00, c01, c10, c11);

        // 7th clock cycle
        #10;
        a00 = 0, a01 = 3, a10 = 4, a11 = 0;
        b00 = 0, b01 = 0, b10 = 0, b11 = 0;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 7", c00, c01, c10, c11);

        // 8th clock cycle
        // Check output of 2nd set
        // Shift last data in - 3rd set
        #10;
        a00 = 0, a01 = 0, a10 = 0, a11 = 9;
        b00 = 0, b01 = 0, b10 = 0, b11 = 0;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 8", c00, c01, c10, c11);

        // 9th clock cycle
        #10;
        a00 = 0, a01 = 0, a10 = 0, a11 = 0;
        b00 = 0, b01 = 0, b10 = 0, b11 = 0;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 9", c00, c01, c10, c11);

        // 10th clock cycle
        // Check output of 3rd set
        #10;
        in_valid = 0;
        a00 = 0, a01 = 0, a10 = 0, a11 = 0;
        b00 = 0, b01 = 0, b10 = 0, b11 = 0;
        $display("c00: %d, c01: %d, c10: %d, c11: %d, clock cycle 10", c00, c01, c10, c11);   

        // 11th clock cycle
        #10;
        a00 = 0, a01 = 0, a10 = 0, a11 = 0;
        b00 = 0, b01 = 0, b10 = 0, b11 = 0;
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