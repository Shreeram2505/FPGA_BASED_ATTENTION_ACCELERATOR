`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 11:42:53
// Design Name: 
// Module Name: row_max_finder
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


module row_max_finder #(

    parameter DATA_WIDTH = 32,
    parameter MAX_SEQ    = 16

)(

    input  logic signed [DATA_WIDTH-1:0]
        row_data [0:MAX_SEQ-1],

    input  logic [15:0] seq_len,

    output logic signed [DATA_WIDTH-1:0]
        row_max

);

integer i;

always_comb
begin

    row_max = row_data[0];

    for(i=1;i<MAX_SEQ;i=i+1)
    begin

        if(i < seq_len)
        begin

            if(row_data[i] > row_max)
                row_max = row_data[i];

        end

    end

end

endmodule
