`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 16:42:43
// Design Name: 
// Module Name: systollic_array_2x2
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


module systollic_array_2x2(
    input clk,
    input rst,

    // Left-side inputs
    input signed [7:0] a0_in,
    input signed [7:0] a1_in,

    // Top-side inputs
    input signed [7:0] b0_in,
    input signed [7:0] b1_in,

    // Results
    output signed [31:0] c00,
    output signed [31:0] c01,
    output signed [31:0] c10,
    output signed [31:0] c11
);



    wire signed [7:0] a00_to_01;
    wire signed [7:0] a10_to_11;

    wire signed [7:0] b00_to_10;
    wire signed [7:0] b01_to_11;


    PE PE00 (
        .clk(clk),
        .rst(rst),

        .a_in(a0_in),
        .b_in(b0_in),

        .a_out(a00_to_01),
        .b_out(b00_to_10),

        .psum_out(c00)
    );



   PE  PE01 (
        .clk(clk),
        .rst(rst),

        .a_in(a00_to_01),
        .b_in(b1_in),

        .a_out(),
        .b_out(b01_to_11),

        .psum_out(c01)
    );



    PE  PE10 (
        .clk(clk),
        .rst(rst),

        .a_in(a1_in),
        .b_in(b00_to_10),

        .a_out(a10_to_11),
        .b_out(),

        .psum_out(c10)
    );


    PE  PE11 (
        .clk(clk),
        .rst(rst),

        .a_in(a10_to_11),
        .b_in(b01_to_11),

        .a_out(),
        .b_out(),

        .psum_out(c11)
    );

endmodule
