`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2026 04:57:41
// Design Name: 
// Module Name: attention_weight_memory
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


module attention_weight_memory #(

    parameter int MAX_SEQ        = 16,
    parameter int SOFTMAX_WIDTH  = 16

)(

    input logic clk,
    input logic rst,

    //----------------------------------
    // Load Control
    //----------------------------------

    input logic load_weights,

    //----------------------------------
    // Softmax Matrix Input
    //----------------------------------

    input logic [SOFTMAX_WIDTH-1:0]
        matrix_in [0:MAX_SEQ-1][0:MAX_SEQ-1],

    //----------------------------------
    // Stored Softmax Matrix
    //----------------------------------

    output logic [SOFTMAX_WIDTH-1:0]
        weight_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1]

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    //----------------------------------
    // Reset
    //----------------------------------

    if(rst)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_SEQ; c=c+1)
            begin

                weight_matrix[r][c] <= '0;

            end

        end

    end

    //----------------------------------
    // Load Softmax Matrix
    //----------------------------------

    else if(load_weights)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_SEQ; c=c+1)
            begin

                weight_matrix[r][c]
                    <= matrix_in[r][c];

            end

        end

    end

end

//--------------------------------------------------
// Debug
//--------------------------------------------------

always @(posedge clk)
begin

    if(load_weights)
    begin

        #1;

        $display("");
        $display("================================");
        $display("ATTENTION WEIGHT MEMORY");
        $display("================================");

        for(int r=0; r<MAX_SEQ; r++)
        begin

            for(int c=0; c<MAX_SEQ; c++)
                $write("%5d ", weight_matrix[r][c]);

            $write("\n");

        end

        $display("");

    end

end

endmodule
