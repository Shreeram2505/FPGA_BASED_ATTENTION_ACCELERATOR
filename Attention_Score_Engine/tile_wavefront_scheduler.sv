
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 21:02:18
// Design Name: 
// Module Name: tile_wavefront_scheduler
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

module tile_wavefront_scheduler #(

    parameter int N = 8,
    parameter int DATA_WIDTH = 8

)(

    input  logic clk,
    input  logic rst,
    input  logic start,

    input logic signed [DATA_WIDTH-1:0]
        tile_A [0:N-1][0:N-1],

    input logic signed [DATA_WIDTH-1:0]
        tile_B [0:N-1][0:N-1],

    output logic signed [DATA_WIDTH-1:0]
        a_stream [0:N-1],

    output logic signed [DATA_WIDTH-1:0]
        b_stream [0:N-1],

    output logic valid,
    output logic clear_acc,
    output logic done

);

localparam int TOTAL_CYCLES = 3*N - 2;

typedef enum logic [1:0]
{
    IDLE_STATE,
    CLEAR_STATE,
    STREAM_STATE,
    DONE_STATE
} state_t;

state_t state;

logic [$clog2(TOTAL_CYCLES+1)-1:0] cycle_count;

integer r;
integer c;



always_ff @(posedge clk)
begin

    if(rst)
    begin

        state       <= IDLE_STATE;
        cycle_count <= '0;
        done        <= 1'b0;

    end

    else
    begin

        done <= 1'b0;

        case(state)



        IDLE_STATE:
        begin

            cycle_count <= '0;

            if(start)
                state <= CLEAR_STATE;

        end

        //----------------------------------
        // CLEAR
        //----------------------------------

        CLEAR_STATE:
        begin

            cycle_count <= '0;

            state <= STREAM_STATE;

        end



        STREAM_STATE:
        begin

            if(cycle_count == TOTAL_CYCLES)
            begin

                state <= DONE_STATE;

            end
            else
            begin

                cycle_count <= cycle_count + 1'b1;

            end

        end



        DONE_STATE:
        begin

            done  <= 1'b1;
            state <= IDLE_STATE;

        end

        endcase

    end

end



always_comb
begin

    valid     = 1'b0;
    clear_acc = 1'b0;

    case(state)

    IDLE_STATE:
    begin

        valid     = 1'b0;
        clear_acc = 1'b0;

    end

    CLEAR_STATE:
    begin

        valid     = 1'b0;
        clear_acc = 1'b1;

    end

    STREAM_STATE:
    begin

        valid     = 1'b1;
        clear_acc = 1'b0;

    end

    DONE_STATE:
    begin

        valid     = 1'b0;
        clear_acc = 1'b0;

    end

    endcase

end



always_comb
begin

    integer idx_local;

    for(r=0; r<N; r=r+1)
    begin

        a_stream[r] = '0;

        if(cycle_count >= r)
        begin

            idx_local = cycle_count - r;

            if(idx_local < N)
                a_stream[r] = tile_A[r][idx_local];

        end

    end

end



always_comb
begin

    integer idx_local;

    for(c=0; c<N; c=c+1)
    begin

        b_stream[c] = '0;

        if(cycle_count >= c)
        begin

            idx_local = cycle_count - c;

            if(idx_local < N)
                b_stream[c] = tile_B[idx_local][c];

        end

    end

end



endmodule