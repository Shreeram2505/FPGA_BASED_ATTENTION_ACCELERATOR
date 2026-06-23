`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.06.2026 22:14:54
// Design Name: 
// Module Name: projection_engine
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


module projection_engine #(

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
    input logic [DIM_WIDTH-1:0] D_MODEL,
    input logic [DIM_WIDTH-1:0] HEAD_DIM,

    output logic done,
    
    output logic signed [ACC_WIDTH-1:0]
    q_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1],

    output logic signed [ACC_WIDTH-1:0]
    k_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1],

    output logic signed [ACC_WIDTH-1:0]
    v_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1]

);

logic gemm_start;
logic gemm_done;

logic load_q;
logic load_k;
logic load_v;

logic [1:0] weight_select;

logic [ADDR_WIDTH-1:0] rd_addr_A;
logic [ADDR_WIDTH-1:0] rd_addr_B;

logic signed [DATA_WIDTH-1:0] x_rd_data;
logic signed [DATA_WIDTH-1:0] weight_rd_data;

localparam WQ_SEL = 2'd0;
localparam WK_SEL = 2'd1;
localparam WV_SEL = 2'd2;

logic signed [ACC_WIDTH-1:0]
    gemm_matrix [0:MAX_SEQ-1][0:MAX_HEAD-1];
    
    
global_memory mem (

    .x_rd_addr(rd_addr_A),
    .x_rd_data(x_rd_data),

    .weight_select(weight_select),

    .weight_rd_addr(rd_addr_B),
    .weight_rd_data(weight_rd_data)

);

top_tiled_gemm #(

    .N(N),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DIM_WIDTH(DIM_WIDTH),

    .MAX_M(MAX_SEQ),
    .MAX_P(MAX_HEAD)

) gemm (

    .clk(clk),
    .rst(rst),

    .start(gemm_start),

    .M(SEQ_LEN),
    .K(D_MODEL),
    .P(HEAD_DIM),

    .rd_addr_A(rd_addr_A),
    .rd_addr_B(rd_addr_B),

    .rd_data_A(x_rd_data),
    .rd_data_B(weight_rd_data),

    .c_matrix(gemm_matrix),

    .done(gemm_done)

);


qkv_memory #(

    .MAX_SEQ(MAX_SEQ),
    .MAX_HEAD(MAX_HEAD),
    .ACC_WIDTH(ACC_WIDTH)

) qkv_mem (

    .clk(clk),
    .rst(rst),

    .load_q(load_q),
    .load_k(load_k),
    .load_v(load_v),

    .matrix_in(gemm_matrix),

    .q_matrix(q_matrix),
    .k_matrix(k_matrix),
    .v_matrix(v_matrix)

);

typedef enum logic [3:0]
{
    IDLE,

    RUN_Q,
    WAIT_Q,
    STORE_Q,

    RUN_K,
    WAIT_K,
    STORE_K,

    RUN_V,
    WAIT_V,
    STORE_V,

    DONE_STATE

} state_t;

state_t state;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        state <= IDLE;

        done <= 0;

        gemm_start <= 0;

        load_q <= 0;
        load_k <= 0;
        load_v <= 0;

        weight_select <= 0;

    end

    else
    begin

        gemm_start <= 0;

        load_q <= 0;
        load_k <= 0;
        load_v <= 0;

        done <= 0;

        case(state)

        IDLE:
        begin

            if(start)
                state <= RUN_Q;

        end

        // Q


    RUN_Q:
begin

    weight_select <= 0;

    gemm_start <= 1;

    state <= WAIT_Q;

end

    WAIT_Q:
begin

    if(gemm_done)
        state <= STORE_Q;

end

    STORE_Q:
begin

    load_q <= 1;

    state <= RUN_K;

end
        // K

    RUN_K:
begin

    weight_select <= 1;

    gemm_start <= 1;

    state <= WAIT_K;

end

    WAIT_K:
begin

    if(gemm_done)
        state <= STORE_K;

end

    STORE_K:
begin

    load_k <= 1;

    state <= RUN_V;

end

        // V
      
    RUN_V:
begin

    weight_select <= 2;

    gemm_start <= 1;

    state <= WAIT_V;

end

    WAIT_V:
begin

    if(gemm_done)
        state <= STORE_V;

end

    STORE_V:
begin

    load_v <= 1;

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



endmodule
