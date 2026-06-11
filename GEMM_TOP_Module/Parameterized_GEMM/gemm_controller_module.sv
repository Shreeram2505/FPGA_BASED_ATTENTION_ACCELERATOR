`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 18:18:20
// Design Name: 
// Module Name: gemm_controller_module
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


module gemm_controller_module #(

    parameter int N = 8

)(

    input  logic clk,
    input  logic rst,
    input  logic start,

    output logic clear_acc,
    output logic valid,
    output logic done,

    output logic [$clog2(4*N)-1:0] cycle_count

);



    localparam int FEED_END  = (2*N) - 1;
    localparam int FLUSH_END = 3*N;



    typedef enum logic [2:0]
    {
        IDLE_STATE,
        CLEAR_STATE,
        PREPARE_STATE,
        FEED_STATE,
        FLUSH_STATE,
        DONE_STATE
    } state_t;

    state_t state;


    always_ff @(posedge clk)
    begin

        if(rst)
        begin

            state       <= IDLE_STATE;
            cycle_count <= '0;

            clear_acc   <= 1'b0;
            valid       <= 1'b0;
            done        <= 1'b0;

        end

        else
        begin

            case(state)



            IDLE_STATE:
            begin

                cycle_count <= '0;

                clear_acc <= 1'b0;
                valid     <= 1'b0;
                done      <= 1'b0;

                if(start)
                    state <= CLEAR_STATE;

            end


            CLEAR_STATE:
            begin

                clear_acc <= 1'b1;
                valid     <= 1'b0;
                done      <= 1'b0;

                cycle_count <= '0;

                state <= PREPARE_STATE;

            end


            PREPARE_STATE:
            begin

                clear_acc <= 1'b0;
                valid     <= 1'b0;
                done      <= 1'b0;

                cycle_count <= '0;

                state <= FEED_STATE;

            end


            FEED_STATE:
            begin

                clear_acc <= 1'b0;
                valid     <= 1'b1;

                if(cycle_count == FEED_END)
                begin

                    cycle_count <= FEED_END + 1;

                    state <= FLUSH_STATE;

                end

                else
                begin

                    cycle_count <= cycle_count + 1'b1;

                end

            end


            FLUSH_STATE:
            begin

                clear_acc <= 1'b0;
                valid     <= 1'b1;

                if(cycle_count >= FLUSH_END)
                begin

                    valid <= 1'b0;

                    state <= DONE_STATE;

                end

                else
                begin

                    cycle_count <= cycle_count + 1'b1;

                end

            end


            DONE_STATE:
            begin

                clear_acc <= 1'b0;
                valid     <= 1'b0;
                done      <= 1'b1;

            end

            endcase

        end

    end

endmodule
