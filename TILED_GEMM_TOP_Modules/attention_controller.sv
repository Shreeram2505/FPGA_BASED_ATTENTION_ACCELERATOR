`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 19:11:28
// Design Name: 
// Module Name: attention_controller
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


module attention_controller(

    input  logic clk,
    input  logic rst,

    input  logic start,
    input  logic scheduler_done,

    output logic scheduler_start,
    output logic done

);

typedef enum logic [1:0] {

    IDLE_STATE,
    RUN_STATE,
    DONE_STATE

} state_t;

state_t state;

always_ff @(posedge clk)
begin

    if(rst)
    begin
        state <= IDLE_STATE;
        scheduler_start <= 0;
        done <= 0;
    end

    else
    begin

        case(state)

        IDLE_STATE:
        begin
            scheduler_start <= 0;
            done <= 0;

            if(start)
            begin
                scheduler_start <= 1;
                state <= RUN_STATE;
            end
        end

        RUN_STATE:
        begin

            scheduler_start <= 0;

            if(scheduler_done)
                state <= DONE_STATE;

        end

        DONE_STATE:
        begin
            done <= 1;
        end

        endcase

    end

end

endmodule
