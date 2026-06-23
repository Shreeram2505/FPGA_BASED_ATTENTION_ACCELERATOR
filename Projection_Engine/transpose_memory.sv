`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 01:49:01
// Design Name: 
// Module Name: transpose_memory
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

module transpose_memory #(

    parameter int MAX_M      = 16,
    parameter int MAX_P      = 16,
    parameter int DATA_WIDTH = 8

)(

    input logic clk,
    input logic rst,
    input logic start,

    input logic signed [DATA_WIDTH-1:0]
        matrix_in [0:MAX_M-1][0:MAX_P-1],

    output logic signed [DATA_WIDTH-1:0]
        matrix_out [0:MAX_P-1][0:MAX_M-1],

    output logic done

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        done <= 1'b0;

        for(r=0; r<MAX_P; r=r+1)
        begin

            for(c=0; c<MAX_M; c=c+1)
            begin

                matrix_out[r][c] <= '0;

            end

        end

    end

    else
    begin

        done <= 1'b0;

        if(start)
        begin

            for(r=0; r<MAX_M; r=r+1)
            begin

                for(c=0; c<MAX_P; c=c+1)
                begin

                    matrix_out[c][r]
                        <= matrix_in[r][c];

                end

            end

            done <= 1'b1;

        end

    end

end

endmodule
