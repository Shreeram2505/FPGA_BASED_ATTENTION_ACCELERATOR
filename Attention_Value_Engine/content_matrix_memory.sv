`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2026 05:54:29
// Design Name: 
// Module Name: content_matrix_memory
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


module context_matrix_memory #(

    parameter int MAX_SEQ   = 16,
    parameter int MAX_HEAD  = 16,
    parameter int ACC_WIDTH = 32

)(

    input logic clk,
    input logic rst,

    //----------------------------------
    // Load Control
    //----------------------------------

    input logic load_context,

    //----------------------------------
    // Context Matrix Input
    //----------------------------------

    input logic signed [ACC_WIDTH-1:0]
        matrix_in [0:MAX_SEQ-1][0:MAX_HEAD-1],

    //----------------------------------
    // Stored Context Matrix
    //----------------------------------

    output logic signed [ACC_WIDTH-1:0]
        context_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1]

);

integer r;
integer c;

//////////////////////////////////////////////////
// Store Context Matrix
//////////////////////////////////////////////////

always_ff @(posedge clk)
begin

    //----------------------------------
    // Reset
    //----------------------------------

    if(rst)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_HEAD; c=c+1)
            begin

                context_matrix[r][c] <= '0;
            end

        end

    end

    //----------------------------------
    // Store Context
    //----------------------------------

    else if(load_context)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_HEAD; c=c+1)
            begin

                context_matrix[r][c]
                    <= matrix_in[r][c];

            end

        end

    end

end

//////////////////////////////////////////////////
// Debug
//////////////////////////////////////////////////

always @(posedge clk)
begin

    if(load_context)
    begin

        #1;

        $display("");
        $display("================================");
        $display("CONTEXT MATRIX MEMORY");
        $display("================================");

        for(int r=0; r<MAX_SEQ; r++)
        begin

            for(int c=0; c<MAX_HEAD; c++)
            begin

                $write("%8d ", context_matrix[r][c]);
            end

            $write("\n");

        end

        $display("");

    end

end

endmodule
