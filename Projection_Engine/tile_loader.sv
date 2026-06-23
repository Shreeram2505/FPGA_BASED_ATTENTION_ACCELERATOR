`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 21:25:52
// Design Name: 
// Module Name: tile_loader
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


module tile_loader #(

    parameter int N = 8,
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 32,
    parameter int DIM_WIDTH  = 16

)(

    input  logic clk,
    input  logic rst,

    input  logic start,

    input  logic [ADDR_WIDTH-1:0] a_tile_base,
    input  logic [ADDR_WIDTH-1:0] b_tile_base,

    input  logic [DIM_WIDTH-1:0] K,
    input  logic [DIM_WIDTH-1:0] P,

    output logic [ADDR_WIDTH-1:0] rd_addr_A,
    output logic [ADDR_WIDTH-1:0] rd_addr_B,

    input  logic signed [DATA_WIDTH-1:0] rd_data_A,
    input  logic signed [DATA_WIDTH-1:0] rd_data_B,

    output logic tileA_wr_en,
    output logic tileB_wr_en,

    output logic [$clog2(N)-1:0] tileA_wr_row,
    output logic [$clog2(N)-1:0] tileA_wr_col,

    output logic [$clog2(N)-1:0] tileB_wr_row,
    output logic [$clog2(N)-1:0] tileB_wr_col,

    output logic signed [DATA_WIDTH-1:0] tileA_wr_data,
    output logic signed [DATA_WIDTH-1:0] tileB_wr_data,

    output logic done

);

typedef enum logic [1:0]
{
    IDLE_STATE,
    LOAD_STATE,
    DONE_STATE
} state_t;

state_t state;

logic [$clog2(N*N):0] load_count;

logic [$clog2(N)-1:0] row_idx;
logic [$clog2(N)-1:0] col_idx;

always_comb
begin

    row_idx = load_count / N;
    col_idx = load_count % N;

end

always_ff @(posedge clk)
begin

    if(rst)
    begin

        state <= IDLE_STATE;

        load_count <= '0;

        tileA_wr_en <= 1'b0;
        tileB_wr_en <= 1'b0;

        done <= 1'b0;

    end

    else
    begin

        done <= 1'b0;

        case(state)



        IDLE_STATE:
        begin

            tileA_wr_en <= 1'b0;
            tileB_wr_en <= 1'b0;

            load_count <= '0;

            if(start)
            begin

                state <= LOAD_STATE;

            end

        end



        LOAD_STATE:
        begin

            tileA_wr_en <= 1'b1;
            tileB_wr_en <= 1'b1;

            if(load_count == (N*N-1))
            begin

                state <= DONE_STATE;

            end

            load_count <= load_count + 1'b1;

        end


        DONE_STATE:
        begin

            tileA_wr_en <= 1'b0;
            tileB_wr_en <= 1'b0;

            done <= 1'b1;

            state <= IDLE_STATE;

        end

        endcase

    end

end

always_comb
begin

    rd_addr_A =
        a_tile_base +
        (row_idx * K) +
        col_idx;

    rd_addr_B =
        b_tile_base +
        (row_idx * P) +
        col_idx;

    tileA_wr_row = row_idx;
    tileA_wr_col = col_idx;

    tileB_wr_row = row_idx;
    tileB_wr_col = col_idx;

    tileA_wr_data = rd_data_A;
    tileB_wr_data = rd_data_B;

end


endmodule