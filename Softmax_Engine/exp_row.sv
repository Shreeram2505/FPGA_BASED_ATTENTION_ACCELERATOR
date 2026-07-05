`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 02:57:06
// Design Name: 
// Module Name: exp_row
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


module exp_row #(

    parameter MAX_SEQ = 16

)(

    input logic signed [31:0]
        shifted_row [0:MAX_SEQ-1],

    output logic [15:0]
        exp_row [0:MAX_SEQ-1]

);

genvar i;

generate

    for(i=0;i<MAX_SEQ;i=i+1)
    begin : EXP_GEN

        exp_lut lut (

            .x(shifted_row[i]),
            .exp_x(exp_row[i])

        );

    end

endgenerate

endmodule
