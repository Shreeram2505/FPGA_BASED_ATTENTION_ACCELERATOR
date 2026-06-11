`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 11:51:28
// Design Name: 
// Module Name: matrix_memory
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

module matrix_memory(

    input clk,

    //--------------------------------------------------
    // Matrix A Addresses
    //--------------------------------------------------

    input [3:0] addr_a0,
    input [3:0] addr_a1,
    input [3:0] addr_a2,
    input [3:0] addr_a3,

    //--------------------------------------------------
    // Matrix B Addresses
    //--------------------------------------------------

    input [3:0] addr_b0,
    input [3:0] addr_b1,
    input [3:0] addr_b2,
    input [3:0] addr_b3,

    //--------------------------------------------------
    // Matrix A Outputs
    //--------------------------------------------------

    output  signed [7:0] data_a0,
    output  signed [7:0] data_a1,
    output  signed [7:0] data_a2,
    output  signed [7:0] data_a3,

    //--------------------------------------------------
    // Matrix B Outputs
    //--------------------------------------------------

    output  signed [7:0] data_b0,
    output  signed [7:0] data_b1,
    output  signed [7:0] data_b2,
    output  signed [7:0] data_b3

);


//--------------------------------------------------
// Memory Arrays
//--------------------------------------------------

reg signed [7:0] mem_A [0:15];
reg signed [7:0] mem_B [0:15];


//--------------------------------------------------
// Initialization
//--------------------------------------------------

initial
begin

    //---------------- Matrix A ----------------

    mem_A[0]  = 1;
    mem_A[1]  = 2;
    mem_A[2]  = 3;
    mem_A[3]  = 4;

    mem_A[4]  = 5;
    mem_A[5]  = 6;
    mem_A[6]  = 7;
    mem_A[7]  = 8;

    mem_A[8]  = 9;
    mem_A[9]  = 10;
    mem_A[10] = 11;
    mem_A[11] = 12;

    mem_A[12] = 13;
    mem_A[13] = 14;
    mem_A[14] = 15;
    mem_A[15] = 16;


    //---------------- Matrix B ----------------

    mem_B[0]  = 1;
    mem_B[1]  = 0;
    mem_B[2]  = 0;
    mem_B[3]  = 0;

    mem_B[4]  = 0;
    mem_B[5]  = 1;
    mem_B[6]  = 0;
    mem_B[7]  = 0;

    mem_B[8]  = 0;
    mem_B[9]  = 0;
    mem_B[10] = 1;
    mem_B[11] = 0;

    mem_B[12] = 0;
    mem_B[13] = 0;
    mem_B[14] = 0;
    mem_B[15] = 1;

end


//--------------------------------------------------
// Read Ports
//--------------------------------------------------

assign data_a0 = mem_A[addr_a0];
assign data_a1 = mem_A[addr_a1];
assign data_a2 = mem_A[addr_a2];
assign data_a3 = mem_A[addr_a3];

assign data_b0 = mem_B[addr_b0];
assign data_b1 = mem_B[addr_b1];
assign data_b2 = mem_B[addr_b2];
assign data_b3 = mem_B[addr_b3];

endmodule