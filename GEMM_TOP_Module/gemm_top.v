`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 12:24:21
// Design Name: 
// Module Name: gemm_top
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


module gemm_top(

    input clk,
    input rst,
    input start,

    output done,

    output signed [31:0] c00,
    output signed [31:0] c01,
    output signed [31:0] c02,
    output signed [31:0] c03,

    output signed [31:0] c10,
    output signed [31:0] c11,
    output signed [31:0] c12,
    output signed [31:0] c13,

    output signed [31:0] c20,
    output signed [31:0] c21,
    output signed [31:0] c22,
    output signed [31:0] c23,

    output signed [31:0] c30,
    output signed [31:0] c31,
    output signed [31:0] c32,
    output signed [31:0] c33

);


//====================================================
// Controller Signals
//====================================================

wire clear_acc;
wire valid;

wire [3:0] cycle_count;


//====================================================
// Address Generator Signals
//====================================================

wire valid_a0;
wire valid_a1;
wire valid_a2;
wire valid_a3;

wire valid_b0;
wire valid_b1;
wire valid_b2;
wire valid_b3;


wire [3:0] addr_a0;
wire [3:0] addr_a1;
wire [3:0] addr_a2;
wire [3:0] addr_a3;

wire [3:0] addr_b0;
wire [3:0] addr_b1;
wire [3:0] addr_b2;
wire [3:0] addr_b3;


//====================================================
// Memory Outputs
//====================================================

wire signed [7:0] data_a0;
wire signed [7:0] data_a1;
wire signed [7:0] data_a2;
wire signed [7:0] data_a3;

wire signed [7:0] data_b0;
wire signed [7:0] data_b1;
wire signed [7:0] data_b2;
wire signed [7:0] data_b3;


//====================================================
// Masked Outputs To SA
//====================================================

wire signed [7:0] a0_sa;
wire signed [7:0] a1_sa;
wire signed [7:0] a2_sa;
wire signed [7:0] a3_sa;

wire signed [7:0] b0_sa;
wire signed [7:0] b1_sa;
wire signed [7:0] b2_sa;
wire signed [7:0] b3_sa;


//====================================================
// GEMM Controller
//====================================================

gemm_controller controller (

    .clk(clk),
    .rst(rst),
    .start(start),

    .clear_acc(clear_acc),
    .valid(valid),
    .done(done),

    .cycle_count(cycle_count)

);


//====================================================
// Address Generator
//====================================================

address_generator addr_gen (

    .cycle_count(cycle_count),

    .valid_a0(valid_a0),
    .valid_a1(valid_a1),
    .valid_a2(valid_a2),
    .valid_a3(valid_a3),

    .valid_b0(valid_b0),
    .valid_b1(valid_b1),
    .valid_b2(valid_b2),
    .valid_b3(valid_b3),

    .addr_a0(addr_a0),
    .addr_a1(addr_a1),
    .addr_a2(addr_a2),
    .addr_a3(addr_a3),

    .addr_b0(addr_b0),
    .addr_b1(addr_b1),
    .addr_b2(addr_b2),
    .addr_b3(addr_b3)

);


//====================================================
// Matrix Memory
//====================================================

matrix_memory memory (

    .clk(clk),

    .addr_a0(addr_a0),
    .addr_a1(addr_a1),
    .addr_a2(addr_a2),
    .addr_a3(addr_a3),

    .addr_b0(addr_b0),
    .addr_b1(addr_b1),
    .addr_b2(addr_b2),
    .addr_b3(addr_b3),

    .data_a0(data_a0),
    .data_a1(data_a1),
    .data_a2(data_a2),
    .data_a3(data_a3),

    .data_b0(data_b0),
    .data_b1(data_b1),
    .data_b2(data_b2),
    .data_b3(data_b3)

);


//====================================================
// Valid Masking
//====================================================

assign a0_sa = valid_a0 ? data_a0 : 8'd0;
assign a1_sa = valid_a1 ? data_a1 : 8'd0;
assign a2_sa = valid_a2 ? data_a2 : 8'd0;
assign a3_sa = valid_a3 ? data_a3 : 8'd0;

assign b0_sa = valid_b0 ? data_b0 : 8'd0;
assign b1_sa = valid_b1 ? data_b1 : 8'd0;
assign b2_sa = valid_b2 ? data_b2 : 8'd0;
assign b3_sa = valid_b3 ? data_b3 : 8'd0;


//====================================================
// Systolic Array
//====================================================

systolic_array_4x4 sa (

    .clk(clk),
    .rst(rst),

    .clear_acc(clear_acc),
    .valid(valid),

    .a0_in(a0_sa),
    .a1_in(a1_sa),
    .a2_in(a2_sa),
    .a3_in(a3_sa),

    .b0_in(b0_sa),
    .b1_in(b1_sa),
    .b2_in(b2_sa),
    .b3_in(b3_sa),

    .c00(c00),
    .c01(c01),
    .c02(c02),
    .c03(c03),

    .c10(c10),
    .c11(c11),
    .c12(c12),
    .c13(c13),

    .c20(c20),
    .c21(c21),
    .c22(c22),
    .c23(c23),

    .c30(c30),
    .c31(c31),
    .c32(c32),
    .c33(c33)

);

endmodule
