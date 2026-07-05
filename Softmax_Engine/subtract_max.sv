`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 02:46:21
// Design Name: 
// Module Name: subtract_max
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


module subtract_max #(

    parameter DATA_WIDTH = 32,
    parameter MAX_SEQ    = 16

)(

    input logic signed [DATA_WIDTH-1:0]
        row_data [0:MAX_SEQ-1],

    input logic signed [DATA_WIDTH-1:0]
        row_max,

    output logic signed [DATA_WIDTH-1:0]
        shifted_row [0:MAX_SEQ-1]

);

genvar i;

generate

    for(i=0;i<MAX_SEQ;i=i+1)
    begin

        assign shifted_row[i]
            = row_data[i] - row_max;

    end

endgenerate

endmodule
