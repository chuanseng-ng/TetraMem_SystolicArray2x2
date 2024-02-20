module SystolicArray2x2 #(
    parameter DATA_WIDTH = 4,
    parameter ACC_WIDTH  = 9,
    parameter LSIZE      = 2.
    parameter RSIZE      = 2
){
    input clk,
    input rstn,
    input in_valid,
    input [DATA_WIDTH-1:0] a00, a01, a10, a11,
    input [DATA_WIDTH-1:0] b00, b01, b10, b11,
    output reg out_valid,
    output reg [ACC_WIDTH-1:0] c00, c01, c10, c11
};

    // Intermediate signals for partial sums, data propagation, and valid signals
    wire [ACC_WIDTH-1:0] part_sum00, part_sum01, part_sum10, part_sum11;
    wire [ACC_WIDTH-1:0] dummy_part_sum;
    wire valid_pe00, valid_pe01, valid_pe10, valid_pe11;

    reg [DATA_WIDTH-1:0] data_pe00, data_pe01, data_pe10, data_pe11;
    reg [ACC_WIDTH-1:0]  temp_c00, temp_c01, temp_c10, temp_c11;
    reg [1:0]            cycle_count = 'd0;
    reg [2:0]            cout_count  = 'd0;
    reg                  cout_check  = 'd0;
    reg                  delayed_in_valid;

    assign dummy_part_sum = 'd0;

    // Instantiate 4 PEs
    ProcessingElement #(DATA_WIDTH, ACC_WIDTH, LSIZE) u_pe00(
        .clk(clk),
        .rstn(rstn),
        .in_valid(in_valid),
        .data_in(data_pe00), // a00 or a10
        .weight_in(b00),
        .part_sum_in(dummy_part_sum),
        .shift_en(1'b0),
        .out_valid(valid_pe00),
        .part_sum_out(part_sum00)
    );

    ProcessingElement #(DATA_WIDTH, ACC_WIDTH, LSIZE) u_pe01(
        .clk(clk),
        .rstn(rstn),
        .in_valid(valid_pe00),
        .data_in(data_pe01), // a00 or a10
        .weight_in(b01),
        .part_sum_in(dummy_part_sum),
        .shift_en(1'b0),
        .out_valid(valid_pe01),
        .part_sum_out(part_sum01)
    );

    ProcessingElement #(DATA_WIDTH, ACC_WIDTH, LSIZE) u_pe10(
        .clk(clk),
        .rstn(rstn),
        .in_valid(valid_pe00),
        .data_in(data_pe10), // a00 or a10
        .weight_in(b10),
        .part_sum_in(part_sum00),
        .shift_en(1'b1),
        .out_valid(valid_pe10),
        .part_sum_out(part_sum10)
    );

    ProcessingElement #(DATA_WIDTH, ACC_WIDTH, LSIZE) u_pe11(
        .clk(clk),
        .rstn(rstn),
        .in_valid(valid_pe01),
        .data_in(data_pe11), // a00 or a10
        .weight_in(b11),
        .part_sum_in(part_sum01),
        .shift_en(1'b1),
        .out_valid(valid_pe11),
        .part_sum_out(part_sum11)
    );

    // Shift matrix A values on each clock cycle
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            data_pe00 <= 'd0;
            data_pe01 <= 'd0;
            data_pe10 <= 'd0;
            data_pe11 <= 'd0;
        end else if (in_valid) begin
            // Shift values to the right
            if (cycle_count == 0) begin
                data_pe00   <= a00;
                cycle_count <= cycle_count + 'b1;
            end else if (cycle_count == 1) begin
                data_pe01   <= data_pe00;
                data_pe00   <= a10;
                data_pe10   <= a01;
                cycle_count <= cycle_count + 'b1;
            end else if (cycle_count == 2) begin
                data_pe11   <= data_pe10;
                data_pe01   <= data_pe00;
                data_pe10   <= a11;
                data_pe00   <= a00;
                cycle_count <= cycle_count + 'b1;
            end else if (cycle_count == 3) begin
                data_pe11   <= data_pe10;
                data_pe01   <= data_pe00;
                data_pe00   <= a10;
                data_pe10   <= a01;
                cycle_count <= 'd2;
            end
        end
    end

    // Control logic for output valid signal
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            out_valid <= 'd0;
        end else begin
            // Output is valid on cycle after last PE has valid output
            out_valid <= valid_pe11;
        end
    end

    always @(posedge in_valid or negedge rstn) begin
        if (~rstn) begin
            delayed_in_valid <= 'd0;
        end else begin
            delayed_in_valid <= 'd1;
        end
    end

    always @* begin
        assign temp_c10 = part_sum10;
        assign temp_c11 = part_sum11;
    end
    
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            c00        <= 'd0;
            c01        <= 'd0;
            c10        <= 'd0;
            c11        <= 'd0;
            temp_c00   <= 'd0;
            temp_c01   <= 'd0;
            temp_c10   <= 'd0;
            temp_c11   <= 'd0;
            temp_c00_2 <= 'd0;
        end else if (delayed_in_valid || out_valid) begin
            if (cout_count == 0) begin
                cout_count <= cout_count + 'b1;
            end else if (cout_count == 1) begin
                c00        <= temp_c10;
                cout_count <= cout_count + 'b1;
            end else if (cout_count == 2) begin
                if (temp_c00_2) begin
                    c00 <= temp_c00_2;
                end
                
                c10        <= temp_c10;
                c01        <= temp_c11;
                cout_count <= cout_count + 'b1;
            end else if (cout_count == 3) begin
                c11        <= temp_c11;
                temp_c00_2 <= temp_c10;
                cout_count <= 'd2;
            end
        end
    end
endmodule