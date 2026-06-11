`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 18:28:00
// Design Name: 
// Module Name: tile_address_generator
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


module tile_address_generator #(

    parameter int TILE_SIZE = 8,
    parameter int ADDR_WIDTH = 32,
    parameter int DIM_WIDTH  = 8

)(

    input logic [DIM_WIDTH-1:0] K,
    input logic [DIM_WIDTH-1:0] P,

    input logic [DIM_WIDTH-1:0] tile_m,
    input logic [DIM_WIDTH-1:0] tile_n,
    input logic [DIM_WIDTH-1:0] tile_k,

    output logic [ADDR_WIDTH-1:0] a_tile_base,
    output logic [ADDR_WIDTH-1:0] b_tile_base,
    output logic [ADDR_WIDTH-1:0] c_tile_base

);

always_comb
begin

    a_tile_base =
        (tile_m * TILE_SIZE * K)
        +
        (tile_k * TILE_SIZE);

    b_tile_base =
        (tile_k * TILE_SIZE * P)
        +
        (tile_n * TILE_SIZE);

    c_tile_base =
        (tile_m * TILE_SIZE * P)
        +
        (tile_n * TILE_SIZE);

end

endmodule
