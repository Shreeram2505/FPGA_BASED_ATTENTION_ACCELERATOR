`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 16:36:36
// Design Name: 
// Module Name: PE
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


module PE(

    input clk,
    input rst,

    input clear_acc,
    input valid,

    input signed [7:0] a_in,
    input signed [7:0] b_in,

    output reg signed [7:0] a_out,
    output reg signed [7:0] b_out,

    output reg signed [31:0] psum_out
);

always @(posedge clk)
begin

    if(rst)
    begin
        a_out    <= 0;
        b_out    <= 0;
        psum_out <= 0;
    end

    else
    begin

        // Forward data every cycle
        a_out <= a_in;
        b_out <= b_in;

        // Clear accumulator
        if(clear_acc)
        begin
            psum_out <= 0;
        end

        // MAC only when valid
        else if(valid)
        begin
            psum_out <= psum_out + (a_in * b_in);
        end

    end

end

endmodule
