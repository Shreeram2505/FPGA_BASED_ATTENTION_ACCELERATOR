`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 11:58:32
// Design Name: 
// Module Name: address_generator
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


module address_generator(

    input [3:0] cycle_count,

    output reg valid_a0,
    output reg valid_a1,
    output reg valid_a2,
    output reg valid_a3,

    output reg valid_b0,
    output reg valid_b1,
    output reg valid_b2,
    output reg valid_b3,

    output reg [3:0] addr_a0,
    output reg [3:0] addr_a1,
    output reg [3:0] addr_a2,
    output reg [3:0] addr_a3,

    output reg [3:0] addr_b0,
    output reg [3:0] addr_b1,
    output reg [3:0] addr_b2,
    output reg [3:0] addr_b3

);

always @(*)
begin

    //----------------------------------
    // Defaults
    //----------------------------------

    valid_a0 = 0;
    valid_a1 = 0;
    valid_a2 = 0;
    valid_a3 = 0;

    valid_b0 = 0;
    valid_b1 = 0;
    valid_b2 = 0;
    valid_b3 = 0;

    addr_a0 = 0;
    addr_a1 = 0;
    addr_a2 = 0;
    addr_a3 = 0;

    addr_b0 = 0;
    addr_b1 = 0;
    addr_b2 = 0;
    addr_b3 = 0;

//----------------------------------
// Row 0
//----------------------------------

if(cycle_count >= 1 && cycle_count <= 4)
begin
    valid_a0 = 1;
    addr_a0 = cycle_count - 1;
end

//----------------------------------
// Row 1
//----------------------------------

if(cycle_count >= 2 && cycle_count <= 5)
begin
    valid_a1 = 1;
    addr_a1 = 4 + (cycle_count - 2);
end

//----------------------------------
// Row 2
//----------------------------------

if(cycle_count >= 3 && cycle_count <= 6)
begin
    valid_a2 = 1;
    addr_a2 = 8 + (cycle_count - 3);
end

//----------------------------------
// Row 3
//----------------------------------

if(cycle_count >= 4 && cycle_count <= 7)
begin
    valid_a3 = 1;
    addr_a3 = 12 + (cycle_count - 4);
end

//----------------------------------
// Column 0
//----------------------------------

if(cycle_count >= 1 && cycle_count <= 4)
begin
    valid_b0 = 1;
    addr_b0 = (cycle_count - 1) * 4;
end

//----------------------------------
// Column 1
//----------------------------------

if(cycle_count >= 2 && cycle_count <= 5)
begin
    valid_b1 = 1;
    addr_b1 = ((cycle_count - 2) * 4) + 1;
end

//----------------------------------
// Column 2
//----------------------------------

if(cycle_count >= 3 && cycle_count <= 6)
begin
    valid_b2 = 1;
    addr_b2 = ((cycle_count - 3) * 4) + 2;
end

//----------------------------------
// Column 3
//----------------------------------

if(cycle_count >= 4 && cycle_count <= 7)
begin
    valid_b3 = 1;
    addr_b3 = ((cycle_count - 4) * 4) + 3;
end

end

endmodule
