`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2026 18:24:57
// Design Name: 
// Module Name: systolic_array_4x4
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


module systolic_array_4x4(

    input clk,
    input rst,

    input clear_acc,
    input valid,

    input signed [7:0] a0_in,
    input signed [7:0] a1_in,
    input signed [7:0] a2_in,
    input signed [7:0] a3_in,

    input signed [7:0] b0_in,
    input signed [7:0] b1_in,
    input signed [7:0] b2_in,
    input signed [7:0] b3_in,

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

parameter N = 4;

wire signed [7:0] a_bus [0:N-1][0:N];
wire signed [7:0] b_bus [0:N][0:N-1];

wire signed [31:0] psum [0:N-1][0:N-1];


assign a_bus[0][0] = a0_in;
assign a_bus[1][0] = a1_in;
assign a_bus[2][0] = a2_in;
assign a_bus[3][0] = a3_in;



assign b_bus[0][0] = b0_in;
assign b_bus[0][1] = b1_in;
assign b_bus[0][2] = b2_in;
assign b_bus[0][3] = b3_in;



genvar r,c;

generate

for(r=0; r<N; r=r+1)
begin: ROWS

    for(c=0; c<N; c=c+1)
    begin: COLS

        PE PE_INST
        (
            .clk(clk),
            .rst(rst),

            .clear_acc(clear_acc),
            .valid(valid),

            .a_in(a_bus[r][c]),
            .b_in(b_bus[r][c]),

            .a_out(a_bus[r][c+1]),
            .b_out(b_bus[r+1][c]),

            .psum_out(psum[r][c])
        );

    end

end

endgenerate


assign c00 = psum[0][0];
assign c01 = psum[0][1];
assign c02 = psum[0][2];
assign c03 = psum[0][3];

assign c10 = psum[1][0];
assign c11 = psum[1][1];
assign c12 = psum[1][2];
assign c13 = psum[1][3];

assign c20 = psum[2][0];
assign c21 = psum[2][1];
assign c22 = psum[2][2];
assign c23 = psum[2][3];

assign c30 = psum[3][0];
assign c31 = psum[3][1];
assign c32 = psum[3][2];
assign c33 = psum[3][3];

endmodule
