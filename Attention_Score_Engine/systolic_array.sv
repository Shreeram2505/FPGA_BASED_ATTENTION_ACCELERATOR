`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 17:35:03
// Design Name: 
// Module Name: systolic_array
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


module systolic_array #(

    parameter int N = 8

)(

    input  logic clk,
    input  logic rst,

    input  logic clear_acc,
    input  logic valid,

    input  logic signed [7:0] a_in [N],
    input  logic signed [7:0] b_in [N],

    output logic signed [31:0] c_out [N][N]

);


logic signed [7:0] a_bus [N][N+1];
logic signed [7:0] b_bus [N+1][N];

logic signed [31:0] psum [N][N];



genvar i;

generate

for(i=0; i<N; i++)
begin : A_INPUTS

    assign a_bus[i][0] = a_in[i];

end

endgenerate



generate

for(i=0; i<N; i++)
begin : B_INPUTS

    assign b_bus[0][i] = b_in[i];

end

endgenerate



genvar r,c;

generate

for(r=0; r<N; r++)
begin : ROWS

    for(c=0; c<N; c++)
    begin : COLS

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



generate

for(r=0; r<N; r++)
begin : OUTPUT_ROWS

    for(c=0; c<N; c++)
    begin : OUTPUT_COLS

        assign c_out[r][c] = psum[r][c];

    end

end

endgenerate

endmodule
