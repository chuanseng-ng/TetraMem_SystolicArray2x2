module ProcessingElement #(
    parameter DATA_WIDTH = 4.
    parameter ACC_WIDTH  = 9,
    parameter SIZE       = 2
)(
    input clk,
    input rstn,
    input in_valid,
    input [DATA_WIDTH-1:0] data_in,
    input [DATA_WIDTH-1:0] weight_in,
    input [ACC_WIDTH-1:0]  part_sum_in,
    input shift_en,
    output reg out_valid,
    output reg [ACC_WIDTH-1:0] part_sum_out
);

    reg [DATA_WIDTH-1:0] prev_weight_in, buff_weight_in, temp_buff_weight_in;
    reg [ACC_WIDTH-1:0]  product, prev_sum_in;
    reg [SIZE-1:0]       data_count      = 'd0;
    reg [SIZE-1:0]       temp_data_count = 'd0;

    reg valid_product;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            assign product       = 'd0;
            assign part_sum_out  = 'd0;
            assign valid_product = 'd0;
        end else if (in_valid) begin
            assign product       = data_in * prev_weight_in;                 // A * B
            assign part_sum_out  = (data_in * prev_weight_in) + prev_sum_in; // (A1 * B1) + (A2 * B2)
            assign valid_product = 'b1;
        end else begin
            assign valid_product = 'b0;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            prev_weight_in      <= 'd0;
            prev_sum_in         <= 'd0;
            buff_weight_in      <= 'd0;
            temp_buff_weight_in <= 'd0;
        end else if (weight_in) begin
            if (data_count == 0) begin
                prev_weight_in <= weight_in;

                if (shift_en) begin
                    temp_data_count <= 'b1;
                end else begin
                    data_count <= 'b1;
                end
            end else if (data_count < SIZE+1) begin
                if (buff_weight_in) begin
                    temp_buff_weight_in <= weight_in;
                end else begin
                    buff_weight_in <= weight_in;
                end
            end
        end

        if (part_sum_in) begin
            prev_sum_in <= part_sum_in;
        end

        if (in_valid) begin
            if (data_count == SIZE+1 && !shift_en) begin
                prev_weight_in      <= buff_weight_in;
                buff_weight_in      <= temp_buff_weight_in;
                temp_buff_weight_in <= weight_in;

                data_count <= 'd2; // Modify to match SIZE parameter
            end else if (temp_data_count == SIZE+1 && shift_en) begin
                prev_weight_in      <= buff_weight_in;
                temp_buff_weight_in <= weight_in;
            end else begin
                if (shift_en) begin
                    temp_data_count <= temp_data_count + 'b1;
                end else begin
                    data_count <= data_count + 'b1;
                end
            end
            
            if (data_count == SIZE+1 && shift_en) begin
                buff_weight_in <= temp_buff_weight_in;
            end
        end

        if (shift_en) begin
            data_count <= temp_data_count;
        end
    end

    always @* begin
        if (~rstn) begin
            assign out_valid = 'b0;
        end else begin
            assign out_valid = valid_product;
        end
    end
endmodule