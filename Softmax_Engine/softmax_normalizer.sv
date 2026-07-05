`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 03:42:15
// Design Name: 
// Module Name: softmax_normalizer
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

module softmax_normalizer #(

    parameter int MAX_SEQ      = 16,
    parameter int EXP_WIDTH     = 16,
    parameter int RECIP_WIDTH   = 16,
    parameter int SOFTMAX_WIDTH = 16

)(

    input logic clk,
    input logic rst,

    input logic start,

    //----------------------------------------
    // Exponential Matrix
    //----------------------------------------

    input logic [EXP_WIDTH-1:0]
        exp_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],

    //----------------------------------------
    // Reciprocal of each Row Sum
    //----------------------------------------

    input logic [RECIP_WIDTH-1:0]
        reciprocal [0:MAX_SEQ-1],

    //----------------------------------------
    // Softmax Output
    //----------------------------------------

    output logic [SOFTMAX_WIDTH-1:0]
        softmax_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],

    output logic done

);

//////////////////////////////////////////////////
// Internal
//////////////////////////////////////////////////

integer r;
integer c;

logic [31:0] mult_result;

//////////////////////////////////////////////////
// Softmax Computation
//////////////////////////////////////////////////

always_ff @(posedge clk)
begin

    if(rst)
    begin

        done <= 0;

        for(r=0;r<MAX_SEQ;r=r+1)
        begin
            for(c=0;c<MAX_SEQ;c=c+1)
            begin

                softmax_matrix[r][c] <= '0;

            end
        end

    end

    else
    begin

        done <= 0;

        if(start)
        begin
             $display("");
            $display("==============================");
            $display("SOFTMAX NORMALIZER");
            $display("==============================");

            for(r=0;r<MAX_SEQ;r=r+1)
            begin

                for(c=0;c<MAX_SEQ;c=c+1)
                begin

                    mult_result =
                        exp_matrix[r][c] *
                        reciprocal[r];
                        
                     $display(
                    "r=%0d c=%0d exp=%0d recip=%0d mult=%0d",
                        r,
                        c,
                        exp_matrix[r][c],
                        reciprocal[r],
                        mult_result
                    );

                    //--------------------------------------------------
                    // Q0.16 Scaling
                    //--------------------------------------------------

                    softmax_matrix[r][c]
                        <= mult_result >> 8;

                end

            end

            done <= 1'b1;

        end

    end

end

endmodule
