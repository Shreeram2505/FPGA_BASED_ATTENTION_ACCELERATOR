`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 02:47:08
// Design Name: 
// Module Name: row_sum
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


module row_sum #(

    parameter DATA_WIDTH = 16,
    parameter MAX_SEQ    = 16,
    parameter SUM_WIDTH  = 32

)(

    input logic [DATA_WIDTH-1:0]
        exp_row [0:MAX_SEQ-1],

    input logic [15:0]
        seq_len,

    output logic [SUM_WIDTH-1:0]
        row_sum

);

integer i;

always_comb
begin

    row_sum = 0;

    for(i=0;i<MAX_SEQ;i=i+1)
    begin

        if(i < seq_len)
            row_sum = row_sum + exp_row[i];

    end

end

endmodule
