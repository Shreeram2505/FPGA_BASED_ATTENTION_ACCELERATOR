`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 03:39:31
// Design Name: 
// Module Name: reciprocal_lut
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


`timescale 1ns / 1ps

module reciprocal_lut #(

    parameter int SUM_WIDTH = 16,
    parameter int RECIP_WIDTH = 32

)(

    input  logic clk,
    input  logic rst,

    input  logic enable,

    input  logic [SUM_WIDTH-1:0] row_sum,

    output logic [RECIP_WIDTH-1:0] reciprocal,

    output logic valid

);

//////////////////////////////////////////////////
// LUT Memory
//////////////////////////////////////////////////

logic [RECIP_WIDTH-1:0] lut [0:4095];

integer i;

//////////////////////////////////////////////////
// LUT Initialization
//////////////////////////////////////////////////

initial
begin

    lut[0] = 0;

    for(i=1;i<4096;i++)
    begin

        lut[i] = (32'd65536) / i;

    end

end

//////////////////////////////////////////////////
// Lookup
//////////////////////////////////////////////////

always_ff @(posedge clk)
begin

    if(rst)
    begin

        reciprocal <= 0;
        valid <= 0;
    end

    else
    begin

        valid <= 0;

        if(enable)
        begin

if(row_sum >4095)

    reciprocal <= lut[4095];

else

    reciprocal <= lut[row_sum];

            valid <= 1;

        end

    end

end

endmodule
