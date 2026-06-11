`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 18:26:44
// Design Name: 
// Module Name: GEMM_Top_Module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GEMM_Top_Module #(

    parameter int N = 8,
    parameter int DATA_WIDTH = 8

)(

    input logic clk,
    input logic rst,
    input logic start,

    input logic wr_en_A,
    input logic wr_en_B,

    input logic [$clog2(N*N)-1:0] wr_addr_A,
    input logic [$clog2(N*N)-1:0] wr_addr_B,

    input logic signed [DATA_WIDTH-1:0] wr_data_A,
    input logic signed [DATA_WIDTH-1:0] wr_data_B,

    output logic done,

    output logic signed [31:0] c_out [N][N]

);

logic clear_acc;
logic valid;

logic [$clog2(4*N)-1:0] cycle_count;

logic valid_a [N];
logic valid_b [N];

logic [$clog2(N*N)-1:0] addr_a [N];
logic [$clog2(N*N)-1:0] addr_b [N];

logic signed [DATA_WIDTH-1:0] data_a [N];
logic signed [DATA_WIDTH-1:0] data_b [N];

logic signed [DATA_WIDTH-1:0] a_sa [N];
logic signed [DATA_WIDTH-1:0] b_sa [N];

gemm_controller_module #(
    .N(N)
)
controller
(
    .clk(clk),
    .rst(rst),
    .start(start),

    .clear_acc(clear_acc),
    .valid(valid),
    .done(done),

    .cycle_count(cycle_count)
);

address_generator_module #(
    .N(N)
)
addr_gen
(
    .cycle_count(cycle_count),

    .valid_a(valid_a),
    .valid_b(valid_b),

    .addr_a(addr_a),
    .addr_b(addr_b)
);

matrix_memory_input #(
    .N(N),
    .DATA_WIDTH(DATA_WIDTH)
)
memory
(
    .clk(clk),

    .wr_en_A(wr_en_A),
    .wr_en_B(wr_en_B),

    .wr_addr_A(wr_addr_A),
    .wr_addr_B(wr_addr_B),

    .wr_data_A(wr_data_A),
    .wr_data_B(wr_data_B),

    .addr_a(addr_a),
    .addr_b(addr_b),

    .data_a(data_a),
    .data_b(data_b)
);

genvar i;

generate

for(i=0;i<N;i++)
begin : MASK_INPUTS

    assign a_sa[i] = valid_a[i] ? data_a[i] : '0;
    assign b_sa[i] = valid_b[i] ? data_b[i] : '0;

end

endgenerate

systolic_array #(
    .N(N)
)
sa
(
    .clk(clk),
    .rst(rst),

    .clear_acc(clear_acc),
    .valid(valid),

    .a_in(a_sa),
    .b_in(b_sa),

    .c_out(c_out)
);

endmodule
