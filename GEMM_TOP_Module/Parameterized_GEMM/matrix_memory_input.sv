`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 17:45:50
// Design Name: 
// Module Name: matrix_memory_input
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


module matrix_memory_input #(

    parameter int N = 8,
    parameter int DATA_WIDTH = 8

)(

    input logic clk,

    input logic wr_en_A,
    input logic wr_en_B,

    input logic [$clog2(N*N)-1:0] wr_addr_A,
    input logic [$clog2(N*N)-1:0] wr_addr_B,

    input logic signed [DATA_WIDTH-1:0] wr_data_A,
    input logic signed [DATA_WIDTH-1:0] wr_data_B,

    input logic [$clog2(N*N)-1:0] addr_a [N],
    input logic [$clog2(N*N)-1:0] addr_b [N],

    output logic signed [DATA_WIDTH-1:0] data_a [N],
    output logic signed [DATA_WIDTH-1:0] data_b [N]

);

    logic signed [DATA_WIDTH-1:0] mem_A [0:N*N-1];
    logic signed [DATA_WIDTH-1:0] mem_B [0:N*N-1];

    initial begin

        $readmemh("matrixA.mem", mem_A);
        $readmemh("matrixB.mem", mem_B);

    end

    always_ff @(posedge clk)
    begin

        if(wr_en_A)
            mem_A[wr_addr_A] <= wr_data_A;

        if(wr_en_B)
            mem_B[wr_addr_B] <= wr_data_B;

    end

    genvar i;

    generate

        for(i=0; i<N; i++)
        begin : READ_PORTS

            assign data_a[i] = mem_A[addr_a[i]];
            assign data_b[i] = mem_B[addr_b[i]];

        end

    endgenerate

endmodule