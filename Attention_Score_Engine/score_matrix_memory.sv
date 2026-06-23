`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 18:25:13
// Design Name: 
// Module Name: score_matrix_memory
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


module score_matrix_memory #(

    parameter int MAX_SEQ   = 16,
    parameter int ACC_WIDTH = 32

)(

    input logic clk,
    input logic rst,

    input logic load,

    input logic signed [ACC_WIDTH-1:0]
        matrix_in [0:MAX_SEQ-1][0:MAX_SEQ-1],

    output logic signed [ACC_WIDTH-1:0]
        score_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1]

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_SEQ; c=c+1)
            begin

                score_matrix[r][c] <= '0;
            end

        end

    end

    else if(load)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_SEQ; c=c+1)
            begin

                score_matrix[r][c]
                    <= matrix_in[r][c];
            end

        end

    end

end

endmodule
