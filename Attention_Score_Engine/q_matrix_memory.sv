`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 23:13:54
// Design Name: 
// Module Name: q_matrix_memory
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


module q_matrix_memory #(

    parameter int MAX_SEQ   = 16,
    parameter int MAX_HEAD  = 16,
    parameter int DATA_WIDTH = 8

)(

    input logic clk,
    input logic rst,

    input logic load,

    input logic signed [DATA_WIDTH-1:0]
        matrix_in [0:MAX_SEQ-1][0:MAX_HEAD-1],

    output logic signed [DATA_WIDTH-1:0]
        matrix_out [0:MAX_SEQ-1][0:MAX_HEAD-1]

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin
            for(c=0; c<MAX_HEAD; c=c+1)
            begin
                matrix_out[r][c] <= '0;
            end
        end

    end

    else if(load)
    begin

        for(r=0; r<MAX_SEQ; r=r+1)
        begin
            for(c=0; c<MAX_HEAD; c=c+1)
            begin
                matrix_out[r][c]
                    <= matrix_in[r][c];
            end
        end

    end

end

endmodule
