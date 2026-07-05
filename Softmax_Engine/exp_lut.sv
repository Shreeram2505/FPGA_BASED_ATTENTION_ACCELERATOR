`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 02:56:17
// Design Name: 
// Module Name: exp_lut
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


module exp_lut #(

    parameter INPUT_WIDTH = 32,
    parameter OUTPUT_WIDTH = 16

)(

    input logic signed [INPUT_WIDTH-1:0]
        x,

    output logic [OUTPUT_WIDTH-1:0]
        exp_x

);

always_comb
begin

    case(x)

         0 : exp_x = 16'd256;

        -1 : exp_x = 16'd94;

        -2 : exp_x = 16'd35;

        -3 : exp_x = 16'd13;

        -4 : exp_x = 16'd5;

        -5 : exp_x = 16'd2;

        -6 : exp_x = 16'd1;

        default:
             exp_x = 16'd0;

    endcase

end

endmodule
