`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 19:18:22
// Design Name: 
// Module Name: tile_buffer
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


module tile_buffer #(

    parameter int N = 8,
    parameter int DATA_WIDTH = 8

)(

    input logic clk,
    input logic rst,

    input logic wr_en,

    input logic [$clog2(N)-1:0] wr_row,
    input logic [$clog2(N)-1:0] wr_col,

    input logic signed [DATA_WIDTH-1:0] wr_data,

    output logic signed [DATA_WIDTH-1:0]
        tile_data [0:N-1][0:N-1]

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        for(r=0; r<N; r=r+1)
        begin

            for(c=0; c<N; c=c+1)
            begin

                tile_data[r][c] <= '0;
            end

        end

    end

    else if(wr_en)
    begin

        tile_data[wr_row][wr_col]
            <= wr_data;

    end

end

endmodule