`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2026 05:47:37
// Design Name: 
// Module Name: attention_value_engine
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


module attention_value_engine #(

    parameter int N               = 8,
    parameter int SOFTMAX_WIDTH   = 16,
    parameter int DATA_WIDTH       = 16,
    parameter int ACC_WIDTH        = 32,
    parameter int ADDR_WIDTH       = 32,
    parameter int DIM_WIDTH        = 16,
    parameter int SCALE_SHIFT      = 8,
    parameter int MAX_SEQ          = 16,
    parameter int MAX_HEAD         = 16

)(

    input logic clk,
    input logic rst,
    input logic start,

    //---------------------------------------
    // Matrix Dimensions
    //---------------------------------------

    input logic [DIM_WIDTH-1:0] SEQ_LEN,
    input logic [DIM_WIDTH-1:0] HEAD_DIM,

    //---------------------------------------
    // Softmax Matrix
    //---------------------------------------

    input logic [SOFTMAX_WIDTH-1:0]
        softmax_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],

    //---------------------------------------
    // Value Matrix
    //---------------------------------------

    input logic signed [DATA_WIDTH-1:0]
        v_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1],

    //---------------------------------------
    // Final Context
    //---------------------------------------

    output logic signed [ACC_WIDTH-1:0]
        context_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1],

    output logic done

);

//////////////////////////////////////////////////
// Control Signals
//////////////////////////////////////////////////

logic load_softmax;
logic load_v;

logic gemm_start;
logic gemm_done;

logic [ADDR_WIDTH-1:0] rd_addr_A;
logic [ADDR_WIDTH-1:0] rd_addr_B;

logic [SOFTMAX_WIDTH-1:0]
    rd_softmax;

logic signed [DATA_WIDTH-1:0]
    rd_v;

logic signed [ACC_WIDTH-1:0]
    gemm_context [0:MAX_SEQ-1][0:MAX_HEAD-1];

//////////////////////////////////////////////////
// Global Memory
//////////////////////////////////////////////////

attention_global_memory #(

    .SOFTMAX_WIDTH(SOFTMAX_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),

    .MAX_SEQ(MAX_SEQ),
    .MAX_HEAD(MAX_HEAD),

    .ADDR_WIDTH(ADDR_WIDTH)

) global_mem (

    .clk(clk),
    .rst(rst),

    .load_softmax(load_softmax),
    .load_v(load_v),
    .SEQ_LEN(SEQ_LEN),
    .HEAD_DIM(HEAD_DIM),

    .softmax_matrix(softmax_matrix),
    .v_matrix(v_matrix),

    .rd_addr_A(rd_addr_A),
    .rd_data_A(rd_softmax),

    .rd_addr_B(rd_addr_B),
    .rd_data_B(rd_v)

);

//////////////////////////////////////////////////
// Tiled GEMM
//////////////////////////////////////////////////

top_tiled_gemm #(

    .N(N),

    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH),

    .ADDR_WIDTH(ADDR_WIDTH),
    .DIM_WIDTH(DIM_WIDTH),
    .SCALE_SHIFT(SCALE_SHIFT),
    .MAX_M(MAX_SEQ),
    .MAX_P(MAX_HEAD)

) gemm (

    .clk(clk),
    .rst(rst),

    .start(gemm_start),

    .M(SEQ_LEN),
    .K(SEQ_LEN),
    .P(HEAD_DIM),

    .rd_addr_A(rd_addr_A),
    .rd_addr_B(rd_addr_B),

    .rd_data_A(rd_softmax),
    .rd_data_B(rd_v),

    .c_matrix(gemm_context),

    .done(gemm_done)

);

//////////////////////////////////////////////////
// Context Memory
//////////////////////////////////////////////////

context_matrix_memory #(

    .MAX_SEQ(MAX_SEQ),
    .MAX_HEAD(MAX_HEAD),
    .ACC_WIDTH(ACC_WIDTH)

) context_mem (

    .clk(clk),
    .rst(rst),

    .load_context(gemm_done),

    .matrix_in(gemm_context),

    .context_matrix(context_matrix)

);

//////////////////////////////////////////////////
// FSM
//////////////////////////////////////////////////

typedef enum logic[2:0]
{

    IDLE,

    LOAD_SOFTMAX,

    LOAD_V,

    RUN_GEMM,

    WAIT_GEMM,

    DONE_STATE

} state_t;

state_t state;

//////////////////////////////////////////////////
// Controller
//////////////////////////////////////////////////

always_ff @(posedge clk)
begin

    if(rst)
    begin

        state <= IDLE;

        load_softmax <= 0;
        load_v <= 0;

        gemm_start <= 0;

        done <= 0;

    end

    else
    begin

        load_softmax <= 0;
        load_v <= 0;

        gemm_start <= 0;

        done <= 0;

        case(state)

        //----------------------------------

        IDLE:
        begin

            if(start)

                state <= LOAD_SOFTMAX;

        end

        //----------------------------------

        LOAD_SOFTMAX:
        begin

            load_softmax <= 1;

            state <= LOAD_V;

        end

        //----------------------------------

        LOAD_V:
        begin

            load_v <= 1;

            state <= RUN_GEMM;

        end

        //----------------------------------

        RUN_GEMM:
        begin

            gemm_start <= 1;

            state <= WAIT_GEMM;

        end

        //----------------------------------

        WAIT_GEMM:
        begin

            if(gemm_done)

                state <= DONE_STATE;

        end

        //----------------------------------

        DONE_STATE:
        begin

            done <= 1;

            state <= IDLE;

        end

        //----------------------------------

        endcase

    end

end

endmodule
