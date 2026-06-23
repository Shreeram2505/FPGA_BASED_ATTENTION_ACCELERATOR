`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 19:19:35
// Design Name: 
// Module Name: result_buffer
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


module result_buffer #(

    parameter int N = 8,
    parameter int ACC_WIDTH = 32

)(

    input logic clk,
    input logic rst,

    input logic clear,

    input logic accumulate,

    input logic signed [ACC_WIDTH-1:0]
        c_tile_in [N][N],

    output logic signed [ACC_WIDTH-1:0]
        c_tile_out [N][N]

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    if(rst || clear)
    begin

        for(r=0; r<N; r=r+1)
        begin

            for(c=0; c<N; c=c+1)
            begin

                c_tile_out[r][c] <= '0;
            end

        end

    end

    else if(accumulate)
    begin

        for(r=0; r<N; r=r+1)
        begin

            for(c=0; c<N; c=c+1)
            begin

                c_tile_out[r][c]
                    <= c_tile_out[r][c]
                     + c_tile_in[r][c];
            end

        end

    end

end

endmodule