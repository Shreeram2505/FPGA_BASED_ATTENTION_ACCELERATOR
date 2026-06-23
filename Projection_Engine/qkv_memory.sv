`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.06.2026 17:33:32
// Design Name: 
// Module Name: qkv_memory
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

module qkv_memory #(

    parameter int MAX_SEQ   = 16,
    parameter int MAX_HEAD  = 16,
    parameter int ACC_WIDTH = 32

)(

    input logic clk,
    input logic rst,

    //----------------------------------
    // Load Controls
    //----------------------------------

    input logic load_q,
    input logic load_k,
    input logic load_v,



    input logic signed [ACC_WIDTH-1:0]
        matrix_in [0:MAX_SEQ-1][0:MAX_HEAD-1],


    output logic signed [ACC_WIDTH-1:0]
        q_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1],

    output logic signed [ACC_WIDTH-1:0]
        k_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1],

    output logic signed [ACC_WIDTH-1:0]
        v_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1]

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

            for(c=0; c<MAX_HEAD; c=c+1)
            begin

                q_matrix[r][c] <= '0;
                k_matrix[r][c] <= '0;
                v_matrix[r][c] <= '0;
            end
        end

    end

    //----------------------------------
    // Load Q
    //----------------------------------

    else if(load_q)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_HEAD; c=c+1)
            begin

                q_matrix[r][c]
                    <= matrix_in[r][c];
            end

        end

    end

    //----------------------------------
    // Load K
    //----------------------------------

    else if(load_k)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_HEAD; c=c+1)
            begin

                k_matrix[r][c]
                    <= matrix_in[r][c];
            end

        end

    end

    //----------------------------------
    // Load V
    //----------------------------------

    else if(load_v)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin

            for(c=0; c<MAX_HEAD; c=c+1)
            begin

                v_matrix[r][c]
                    <= matrix_in[r][c];
            end

        end

    end

end

endmodule