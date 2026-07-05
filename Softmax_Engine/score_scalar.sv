`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2026 20:54:55
// Design Name: 
// Module Name: score_scalar
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


module score_scaler #(

    parameter int MAX_SEQ   = 16,
    parameter int ACC_WIDTH = 32

)(

    input logic clk,
    input logic rst,

    input logic start,

    input logic signed [ACC_WIDTH-1:0]
        score_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],

    output logic signed [ACC_WIDTH-1:0]
        scaled_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],

    output logic done

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        done <= 0;

        for(r=0;r<MAX_SEQ;r=r+1)
        begin
            for(c=0;c<MAX_SEQ;c=c+1)
            begin
                scaled_matrix[r][c] <= '0;
            end
        end

    end

    else
    begin

        done <= 0;

        if(start)
        begin

            for(r=0;r<MAX_SEQ;r=r+1)
            begin

                for(c=0;c<MAX_SEQ;c=c+1)
                begin

                    scaled_matrix[r][c]
                        <= score_matrix[r][c] >>> 1;

                end

            end

            done <= 1;

        end

    end

end

endmodule
