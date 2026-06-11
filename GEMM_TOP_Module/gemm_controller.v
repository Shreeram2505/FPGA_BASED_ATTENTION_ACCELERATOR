`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 12:02:52
// Design Name: 
// Module Name: gemm_controller
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


module gemm_controller(

    input clk,
    input rst,
    input start,

    output reg clear_acc,
    output reg valid,
    output reg done,

    output reg [3:0] cycle_count

);

localparam IDLE_STATE  = 3'd0;
localparam CLEAR_STATE = 3'd1;
localparam PREPARE_STATE = 3'd2;
localparam FEED_STATE    = 3'd3;
localparam FLUSH_STATE   = 3'd4;
localparam DONE_STATE    = 3'd5;

reg [2:0] state;

always @(posedge clk)
begin

    if(rst)
    begin

        state <= IDLE_STATE;

        cycle_count <= 0;

        clear_acc <= 0;
        valid <= 0;
        done <= 0;

    end

    else
    begin

        case(state)

        //----------------------------------
        // IDLE
        //----------------------------------

        IDLE_STATE:
        begin

            cycle_count <= 0;

            clear_acc <= 0;
            valid <= 0;
            done <= 0;

            if(start)
                state <= CLEAR_STATE;

        end

        //----------------------------------
        // CLEAR
        //----------------------------------

        CLEAR_STATE:
        begin
            clear_acc <= 1;
            valid <= 0;
            done <= 0;
            cycle_count <= 0;

            state <= PREPARE_STATE;
        end
        
        PREPARE_STATE:
        begin
            clear_acc <= 0;
            valid <= 0;
            done <= 0;
            cycle_count <= 0;

            state <= FEED_STATE;
        end
        
        //----------------------------------
        // FEED
        //----------------------------------

FEED_STATE:
begin

    clear_acc <= 0;
    valid <= 1;

    if(cycle_count == 7)
    begin
        cycle_count <= 8;
        state <= FLUSH_STATE;
    end
    else
    begin
        cycle_count <= cycle_count + 1;
    end

end

        //----------------------------------
        // FLUSH
        //----------------------------------

FLUSH_STATE:
begin

    clear_acc <= 0;
    valid <= 1;

    if(cycle_count >= 12)
    begin
        valid <= 0;
        state <= DONE_STATE;
    end
    else
    begin
        cycle_count <= cycle_count + 1;
    end

end

        //----------------------------------
        // DONE
        //----------------------------------

        DONE_STATE:
        begin

            clear_acc <= 0;
            valid <= 0;
            done <= 1;
        end

        endcase

    end

end

endmodule
