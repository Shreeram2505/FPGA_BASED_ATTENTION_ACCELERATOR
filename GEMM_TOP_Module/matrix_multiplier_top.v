`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 00:23:58
// Design Name: 
// Module Name: matrix_multiplier_top
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


module matrix_multiplier_top(

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

wire clear_acc;
wire valid;

wire signed [7:0] a0_in;
wire signed [7:0] a1_in;
wire signed [7:0] a2_in;
wire signed [7:0] a3_in;

wire signed [7:0] b0_in;
wire signed [7:0] b1_in;
wire signed [7:0] b2_in;
wire signed [7:0] b3_in;

wavefront_scheduler scheduler (

    .clk(clk),
    .rst(rst),
    .start(start),

    .clear_acc(clear_acc),
    .valid(valid),
    .done(done),

    .a0_in(a0_in),
    .a1_in(a1_in),
    .a2_in(a2_in),
    .a3_in(a3_in),

    .b0_in(b0_in),
    .b1_in(b1_in),
    .b2_in(b2_in),
    .b3_in(b3_in)
);

systolic_array_4x4 sa (

    .clk(clk),
    .rst(rst),

    .clear_acc(clear_acc),
    .valid(valid),

    .a0_in(a0_in),
    .a1_in(a1_in),
    .a2_in(a2_in),
    .a3_in(a3_in),

    .b0_in(b0_in),
    .b1_in(b1_in),
    .b2_in(b2_in),
    .b3_in(b3_in),

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
