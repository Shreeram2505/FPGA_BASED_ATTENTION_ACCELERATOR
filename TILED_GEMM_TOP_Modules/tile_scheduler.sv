`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 18:14:08
// Design Name: 
// Module Name: tile_scheduler
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


module tile_scheduler #(

    parameter int TILE_SIZE = 8,
    parameter int DIM_WIDTH = 8

)(

    input logic clk,
    input logic rst,

    input logic start,

    input logic tile_done,

    input logic [DIM_WIDTH-1:0] M,
    input logic [DIM_WIDTH-1:0] K,
    input logic [DIM_WIDTH-1:0] P,

    output logic [DIM_WIDTH-1:0] tile_m,
    output logic [DIM_WIDTH-1:0] tile_n,
    output logic [DIM_WIDTH-1:0] tile_k,

    output logic issue_tile,
    output logic done

);

logic [DIM_WIDTH-1:0] M_tiles;
logic [DIM_WIDTH-1:0] K_tiles;
logic [DIM_WIDTH-1:0] P_tiles;

always_comb
begin

    M_tiles = (M + TILE_SIZE - 1)/TILE_SIZE;
    K_tiles = (K + TILE_SIZE - 1)/TILE_SIZE;
    P_tiles = (P + TILE_SIZE - 1)/TILE_SIZE;

end

typedef enum logic [1:0] {

    IDLE_STATE,
    ISSUE_STATE,
    WAIT_STATE,
    DONE_STATE

} state_t;

state_t state;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        state <= IDLE_STATE;

        tile_m <= 0;
        tile_n <= 0;
        tile_k <= 0;

        issue_tile <= 0;
        done <= 0;

    end

    else
    begin

        case(state)

        IDLE_STATE:
        begin

            issue_tile <= 0;
            done <= 0;

            tile_m <= 0;
            tile_n <= 0;
            tile_k <= 0;

            if(start)
                state <= ISSUE_STATE;

        end

        ISSUE_STATE:
        begin

            issue_tile <= 1;

            state <= WAIT_STATE;

        end

        WAIT_STATE:
        begin

            issue_tile <= 0;

            if(tile_done)
            begin

                if(tile_k < K_tiles-1)
                begin

                    tile_k <= tile_k + 1;
                    state <= ISSUE_STATE;

                end

                else if(tile_n < P_tiles-1)
                begin

                    tile_k <= 0;
                    tile_n <= tile_n + 1;
                    state <= ISSUE_STATE;

                end

                else if(tile_m < M_tiles-1)
                begin

                    tile_k <= 0;
                    tile_n <= 0;
                    tile_m <= tile_m + 1;
                    state <= ISSUE_STATE;

                end

                else
                begin

                    state <= DONE_STATE;

                end

            end

        end

        DONE_STATE:
        begin

            done <= 1;

        end

        endcase

    end

end

always @(posedge clk)
begin

    if(issue_tile)
    begin

        $display(
        "ISSUE tile_m=%0d tile_n=%0d tile_k=%0d",
        tile_m,
        tile_n,
        tile_k
        );

    end

end

endmodule