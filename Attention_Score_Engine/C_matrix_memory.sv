`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2026 03:08:34
// Design Name: 
// Module Name: C_matrix_memory
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


module c_matrix_memory #(

    parameter int N          = 8,
    parameter int MAX_M      = 16,
    parameter int MAX_P      = 16,
    parameter int ACC_WIDTH  = 32,
    parameter int DIM_WIDTH  = 16

)(

    input logic clk,
    input logic rst,

    input logic write_tile,

    input logic [DIM_WIDTH-1:0] tile_m,
    input logic [DIM_WIDTH-1:0] tile_n,

    input logic signed [ACC_WIDTH-1:0]
        tile_data [0:N-1][0:N-1],

    output logic signed [ACC_WIDTH-1:0]
        c_matrix [0:MAX_M-1][0:MAX_P-1]

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        for(r=0; r<MAX_M; r=r+1)
        begin

            for(c=0; c<MAX_P; c=c+1)
            begin

                c_matrix[r][c] <= '0;
            end

        end

    end

    else if(write_tile)
    begin

        for(r=0; r<N; r=r+1)
        begin

            for(c=0; c<N; c=c+1)
            begin

                c_matrix[
                    tile_m*N + r
                ][
                    tile_n*N + c
                ]
                <= tile_data[r][c];

            end

        end

    end

end

endmodule
