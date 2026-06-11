`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2026 19:03:44
// Design Name: 
// Module Name: mac_processing_element
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


module mac_processing_element(
    input  logic clk,
    input  logic rst,

    input  logic signed [7:0] a,
    input  logic signed [7:0] b,

    input  logic signed [31:0] acc_in,

    output logic signed [31:0] result
);

logic signed [15:0] mul_result;

always_ff @(posedge clk) begin
    if(rst) begin
        mul_result <= 0;
        result     <= 0;
    end
    else begin
        mul_result <=  $signed(a) * $signed(b);
        result     <= acc_in + mul_result;
    end
end

endmodule
