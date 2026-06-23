`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 23:32:43
// Design Name: 
// Module Name: attention_score_engine
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


module attention_score_engine #(

    parameter int N           = 8,
    parameter int DATA_WIDTH  = 8,
    parameter int ACC_WIDTH   = 32,
    parameter int ADDR_WIDTH  = 32,
    parameter int DIM_WIDTH   = 16,

    parameter int MAX_SEQ     = 16,
    parameter int MAX_HEAD    = 16

)(

    input logic clk,
    input logic rst,
    input logic start,

    input logic [DIM_WIDTH-1:0] SEQ_LEN,
    input logic [DIM_WIDTH-1:0] HEAD_DIM,



    input logic signed [DATA_WIDTH-1:0]
        q_matrix_in [0:MAX_SEQ-1][0:MAX_HEAD-1],

    input logic signed [DATA_WIDTH-1:0]
        k_matrix_in [0:MAX_SEQ-1][0:MAX_HEAD-1],


    output logic signed [ACC_WIDTH-1:0]
        score_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],

    output logic done

);



logic load_q_mem;
logic load_qkt_mem;

logic load_kt_mem;
logic load_kt_global;

logic load_score;

logic transpose_start;
logic transpose_done;

logic gemm_start;
logic gemm_done;



logic signed [DATA_WIDTH-1:0]
    q_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1];

q_matrix_memory #(

    .MAX_SEQ(MAX_SEQ),
    .MAX_HEAD(MAX_HEAD),
    .DATA_WIDTH(DATA_WIDTH)

) q_mem (

    .clk(clk),
    .rst(rst),

    .load(load_q_mem),

    .matrix_in(q_matrix_in),

    .matrix_out(q_matrix)

);



logic signed [DATA_WIDTH-1:0]
    kt_temp [0:MAX_HEAD-1][0:MAX_SEQ-1];

transpose_memory #(

    .MAX_M(MAX_SEQ),
    .MAX_P(MAX_HEAD),
    .DATA_WIDTH(DATA_WIDTH)

) transpose_k (

    .clk(clk),
    .rst(rst),

    .start(transpose_start),

    .matrix_in(k_matrix_in),

    .matrix_out(kt_temp),

    .done(transpose_done)

);



logic signed [DATA_WIDTH-1:0]
    kt_matrix [0:MAX_HEAD-1][0:MAX_SEQ-1];

kt_matrix_memory #(

    .MAX_SEQ(MAX_SEQ),
    .MAX_HEAD(MAX_HEAD),
    .DATA_WIDTH(DATA_WIDTH)

) kt_mem (

    .clk(clk),
    .rst(rst),

    .load(load_kt_mem),

    .matrix_in(kt_temp),

    .matrix_out(kt_matrix)

);


logic [ADDR_WIDTH-1:0] rd_addr_A;
logic [ADDR_WIDTH-1:0] rd_addr_B;

logic signed [DATA_WIDTH-1:0] rd_data_A;
logic signed [DATA_WIDTH-1:0] rd_data_B;

qkt_global_memory #(

    .MAX_SEQ(MAX_SEQ),
    .MAX_HEAD(MAX_HEAD),
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)

) qkt_mem (

    .clk(clk),
    .rst(rst),
    .SEQ_LEN(SEQ_LEN),
    .HEAD_DIM(HEAD_DIM),
    .load_q(load_qkt_mem),
    .load_kt(load_kt_global),

    .q_matrix(q_matrix),
    .kt_matrix(kt_matrix),

    .rd_addr_A(rd_addr_A),
    .rd_addr_B(rd_addr_B),

    .rd_data_A(rd_data_A),
    .rd_data_B(rd_data_B)

);



logic signed [ACC_WIDTH-1:0]
    gemm_score [0:MAX_SEQ-1][0:MAX_SEQ-1];

top_tiled_gemm #(

    .N(N),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DIM_WIDTH(DIM_WIDTH),

    .MAX_M(MAX_SEQ),
    .MAX_P(MAX_SEQ)

) qkt_gemm (

    .clk(clk),
    .rst(rst),

    .start(gemm_start),

    .M(SEQ_LEN),
    .K(HEAD_DIM),
    .P(SEQ_LEN),

    .rd_addr_A(rd_addr_A),
    .rd_addr_B(rd_addr_B),

    .rd_data_A(rd_data_A),
    .rd_data_B(rd_data_B),

    .c_matrix(gemm_score),

    .done(gemm_done)

);



score_matrix_memory #(

    .MAX_SEQ(MAX_SEQ),
    .ACC_WIDTH(ACC_WIDTH)

) score_mem (

    .clk(clk),
    .rst(rst),

    .load(load_score),

    .matrix_in(gemm_score),

    .score_matrix(score_matrix)

);



typedef enum logic [4:0]
{
    IDLE,

    LOAD_Q_MEM,
    WAIT_Q_MEM,

    LOAD_QKT_MEM,

    TRANSPOSE_K,
    WAIT_TRANSPOSE,

    LOAD_KT_MEM,
    WAIT_KT_MEM,

    LOAD_KT_GLOBAL,

    RUN_GEMM,
    WAIT_GEMM,

    STORE_SCORE,

    DONE_STATE

} state_t;

state_t state;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        state <= IDLE;

        done <= 0;

        load_q_mem <= 0;
        load_qkt_mem <= 0;

        load_kt_mem <= 0;
        load_kt_global <= 0;
        load_score <= 0;

        transpose_start <= 0;
        gemm_start <= 0;

    end

    else
    begin

        done <= 0;

        load_q_mem <= 0;
        load_qkt_mem <= 0;

        load_kt_mem <= 0;
        load_kt_global <= 0;
        load_score <= 0;

        transpose_start <= 0;
        gemm_start <= 0;

        case(state)

        IDLE:
        begin
            if(start)
                state <= LOAD_Q_MEM;
        end

        LOAD_Q_MEM:
        begin
            load_q_mem <= 1;
            state <= WAIT_Q_MEM;
        end

        WAIT_Q_MEM:
        begin
            state <= LOAD_QKT_MEM;
        end

        LOAD_QKT_MEM:
        begin
            load_qkt_mem <= 1;
            state <= TRANSPOSE_K;
        end

        TRANSPOSE_K:
        begin
            transpose_start <= 1;
            state <= WAIT_TRANSPOSE;
        end

        WAIT_TRANSPOSE:
        begin
            if(transpose_done)
                state <= LOAD_KT_MEM;
        end

        LOAD_KT_MEM:
        begin
            load_kt_mem <= 1;
            state <= WAIT_KT_MEM;
        end

        WAIT_KT_MEM:
        begin
            state <= LOAD_KT_GLOBAL;
        end

        LOAD_KT_GLOBAL:
        begin
            load_kt_global <= 1;
            state <= RUN_GEMM;
        end

        RUN_GEMM:
        begin
            gemm_start <= 1;
            state <= WAIT_GEMM;
        end

        WAIT_GEMM:
        begin
            if(gemm_done)
                state <= STORE_SCORE;
        end

        STORE_SCORE:
        begin
            load_score <= 1;
            state <= DONE_STATE;
        end

        DONE_STATE:
        begin
            done <= 1;
            state <= IDLE;
        end

        endcase

    end

end

always @(posedge clk)
begin

    if(transpose_done)
    begin

        $display("");
        $display("====================================");
        $display("KT MATRIX");
        $display("====================================");

        for(int r=0; r<HEAD_DIM; r++)
        begin
            for(int c=0; c<SEQ_LEN; c++)
                $write("%4d ", kt_temp[r][c]);

            $write("\n");
        end

        $display("");

    end

end



endmodule