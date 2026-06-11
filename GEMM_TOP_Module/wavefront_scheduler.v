`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2026 01:20:26
// Design Name: 
// Module Name: wavefront_scheduler
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

module wavefront_scheduler(

    input clk,
    input rst,
    input start,

    output reg clear_acc,
    output reg valid,
    output reg done,

    output reg signed [7:0] a0_in,
    output reg signed [7:0] a1_in,
    output reg signed [7:0] a2_in,
    output reg signed [7:0] a3_in,

    output reg signed [7:0] b0_in,
    output reg signed [7:0] b1_in,
    output reg signed [7:0] b2_in,
    output reg signed [7:0] b3_in
);

//--------------------------------------------------
// State Encoding
//--------------------------------------------------

localparam IDLE_STATE  = 3'd0;
localparam CLEAR_STATE = 3'd1;
localparam FEED_STATE  = 3'd2;
localparam FLUSH_STATE = 3'd3;
localparam DONE_STATE  = 3'd4;

reg [2:0] state;
reg [3:0] cycle_count;

//--------------------------------------------------
// FSM
//--------------------------------------------------

always @(posedge clk)
begin

    if(rst)
    begin

        state <= IDLE_STATE;
        cycle_count <= 0;

        clear_acc <= 0;
        valid <= 0;
        done <= 0;

        a0_in <= 0;
        a1_in <= 0;
        a2_in <= 0;
        a3_in <= 0;

        b0_in <= 0;
        b1_in <= 0;
        b2_in <= 0;
        b3_in <= 0;

    end

    else
    begin

        case(state)

        //--------------------------------------------------
        // IDLE
        //--------------------------------------------------

        IDLE_STATE:
        begin

            done <= 0;
            valid <= 0;
            clear_acc <= 0;

            if(start)
                state <= CLEAR_STATE;

        end

        //--------------------------------------------------
        // CLEAR
        //--------------------------------------------------

        CLEAR_STATE:
        begin

            clear_acc <= 1;
            valid <= 0;
            cycle_count <= 0;

            state <= FEED_STATE;

        end

        //--------------------------------------------------
        // FEED
        //--------------------------------------------------

        FEED_STATE:
        begin

            clear_acc <= 0;
            valid <= 1;

            //---------------- Row 0 ----------------

            case(cycle_count)
                0: a0_in <= 1;
                1: a0_in <= 2;
                2: a0_in <= 3;
                3: a0_in <= 4;
                default: a0_in <= 0;
            endcase

            //---------------- Row 1 ----------------

            case(cycle_count)
                1: a1_in <= 5;
                2: a1_in <= 6;
                3: a1_in <= 7;
                4: a1_in <= 8;
                default: a1_in <= 0;
            endcase

            //---------------- Row 2 ----------------

            case(cycle_count)
                2: a2_in <= 9;
                3: a2_in <= 10;
                4: a2_in <= 11;
                5: a2_in <= 12;
                default: a2_in <= 0;
            endcase

            //---------------- Row 3 ----------------

            case(cycle_count)
                3: a3_in <= 13;
                4: a3_in <= 14;
                5: a3_in <= 15;
                6: a3_in <= 16;
                default: a3_in <= 0;
            endcase

            //---------------- Column 0 ----------------

            case(cycle_count)
                0: b0_in <= 1;
                1: b0_in <= 0;
                2: b0_in <= 0;
                3: b0_in <= 0;
                default: b0_in <= 0;
            endcase

            //---------------- Column 1 ----------------

            case(cycle_count)
                1: b1_in <= 0;
                2: b1_in <= 1;
                3: b1_in <= 0;
                4: b1_in <= 0;
                default: b1_in <= 0;
            endcase

            //---------------- Column 2 ----------------

            case(cycle_count)
                2: b2_in <= 0;
                3: b2_in <= 0;
                4: b2_in <= 1;
                5: b2_in <= 0;
                default: b2_in <= 0;
            endcase

            //---------------- Column 3 ----------------

            case(cycle_count)
                3: b3_in <= 0;
                4: b3_in <= 0;
                5: b3_in <= 0;
                6: b3_in <= 1;
                default: b3_in <= 0;
            endcase

            cycle_count <= cycle_count + 1;

            if(cycle_count == 6)
                state <= FLUSH_STATE;

        end

        //--------------------------------------------------
        // FLUSH
        //--------------------------------------------------

        FLUSH_STATE:
        begin

            valid <= 1;

            a0_in <= 0;
            a1_in <= 0;
            a2_in <= 0;
            a3_in <= 0;

            b0_in <= 0;
            b1_in <= 0;
            b2_in <= 0;
            b3_in <= 0;

            cycle_count <= cycle_count + 1;

            if(cycle_count == 12)
                state <= DONE_STATE;

        end

        //--------------------------------------------------
        // DONE
        //--------------------------------------------------

        DONE_STATE:
        begin

            done <= 1;
            valid <= 0;
            clear_acc <= 0;

        end

        default:
        begin
            state <= IDLE_STATE;
        end

        endcase

    end

end

endmodule