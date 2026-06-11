`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 01:12:57
// Design Name: 
// Module Name: transpose_buffer
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

module transpose_buffer #(

    parameter int N = 8,
    parameter int DATA_WIDTH = 8

)(

    input logic signed [DATA_WIDTH-1:0]
        tile_in [0:N-1][0:N-1],

    output logic signed [DATA_WIDTH-1:0]
        tile_out [0:N-1][0:N-1]

);

integer r;
integer c;

always_comb
begin

    for(r=0; r<N; r=r+1)
    begin

        for(c=0; c<N; c=c+1)
        begin

            tile_out[r][c] = tile_in[c][r];
        end

    end

end

endmodule
