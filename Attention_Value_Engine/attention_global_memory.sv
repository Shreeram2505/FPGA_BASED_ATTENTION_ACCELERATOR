`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2026 05:02:52
// Design Name: 
// Module Name: attention_global_memory
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


module attention_global_memory #(

    parameter int SOFTMAX_WIDTH = 16,
    parameter int DATA_WIDTH     = 32,

    parameter int MAX_SEQ        = 16,
    parameter int MAX_HEAD       = 16,

    parameter int ADDR_WIDTH     = 32

)(

    input logic clk,
    input logic rst,

    //----------------------------------
    // Load Controls
    //----------------------------------
    
    input logic [15:0] SEQ_LEN,
    input logic [15:0] HEAD_DIM,

    input logic load_softmax,
    input logic load_v,

    //----------------------------------
    // Matrix Inputs
    //----------------------------------

    input logic [SOFTMAX_WIDTH-1:0]
        softmax_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],

    input logic signed [DATA_WIDTH-1:0]
        v_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1],

    //----------------------------------
    // GEMM Read Port A
    //----------------------------------

    input logic [ADDR_WIDTH-1:0]
        rd_addr_A,

    output logic [SOFTMAX_WIDTH-1:0]
        rd_data_A,

    //----------------------------------
    // GEMM Read Port B
    //----------------------------------

    input logic [ADDR_WIDTH-1:0]
        rd_addr_B,

    output logic signed [DATA_WIDTH-1:0]
        rd_data_B

);

    //--------------------------------------------------
    // Internal Memories
    //--------------------------------------------------

    logic [SOFTMAX_WIDTH-1:0]
        softmax_mem [0:(MAX_SEQ*MAX_SEQ)-1];

    logic signed [DATA_WIDTH-1:0]
        v_mem [0:(MAX_SEQ*MAX_HEAD)-1];

    integer r;
    integer c;

    //--------------------------------------------------
    // Store Softmax Matrix
    //--------------------------------------------------

    always_ff @(posedge clk)
    begin

        if(rst)
        begin

            for(r=0;r<MAX_SEQ*MAX_SEQ;r=r+1)
                softmax_mem[r] <= '0;

        end

        else if(load_softmax)
        begin

            for(r=0;r<SEQ_LEN;r=r+1)
            begin

                for(c=0;c<HEAD_DIM;c=c+1)
                begin

                    softmax_mem[r*HEAD_DIM+c]
                        <= softmax_matrix[r][c];

                end

            end

        end

    end

    //--------------------------------------------------
    // Store V Matrix
    //--------------------------------------------------

    always_ff @(posedge clk)
    begin

        if(rst)
        begin

            for(r=0;r<MAX_SEQ*MAX_HEAD;r=r+1)
                v_mem[r] <= '0;

        end

        else if(load_v)
        begin

            for(r=0;r<HEAD_DIM;r=r+1)
            begin

                for(c=0;c<SEQ_LEN;c=c+1)
                begin

                    v_mem[r*SEQ_LEN+c]
                        <= v_matrix[r][c];

                end

            end

        end

    end

    //--------------------------------------------------
    // Read Port A
    // Softmax
    //--------------------------------------------------

    assign rd_data_A =
        softmax_mem[rd_addr_A];

    //--------------------------------------------------
    // Read Port B
    // V
    //--------------------------------------------------

    assign rd_data_B =
        v_mem[rd_addr_B];

    //--------------------------------------------------
    // Debug : Softmax Memory
    //--------------------------------------------------

    always @(posedge clk)
    begin

        if(load_softmax)
        begin

            #2;

            $display("");
            $display("================================");
            $display("SOFTMAX MEMORY");
            $display("================================");

            for(int i=0;i<64;i++)
                $write("%0d ",softmax_mem[i]);

            $display("");

        end

    end

    //--------------------------------------------------
    // Debug : V Memory
    //--------------------------------------------------

    always @(posedge clk)
    begin

        if(load_v)
        begin

            #2;

            $display("");
            $display("================================");
            $display("V MEMORY");
            $display("================================");

            for(int i=0;i<64;i++)
                $write("%0d ",v_mem[i]);

            $display("");

        end

    end

    //--------------------------------------------------
    // Debug : Read Addresses
    //--------------------------------------------------

    always @(posedge clk)
    begin

        if(rd_addr_A < (MAX_SEQ*MAX_SEQ))
        begin

            $display(
            "READ SOFTMAX addr=%0d data=%0d",
            rd_addr_A,
            softmax_mem[rd_addr_A]
            );

        end

        if(rd_addr_B < (MAX_SEQ*MAX_HEAD))
        begin

            $display(
            "READ V addr=%0d data=%0d",
            rd_addr_B,
            v_mem[rd_addr_B]
            );

        end

    end

endmodule
