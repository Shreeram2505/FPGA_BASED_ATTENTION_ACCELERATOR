`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 18:12:42
// Design Name: 
// Module Name: address_generator_module
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


module address_generator_module #(

    parameter int N = 8

)(

    input  logic [$clog2(3*N)-1:0] cycle_count,

    output logic valid_a [N],
    output logic valid_b [N],



    output logic [$clog2(N*N)-1:0] addr_a [N],
    output logic [$clog2(N*N)-1:0] addr_b [N]

);

integer i;

always_comb
begin


    for(i=0; i<N; i++)
    begin

        valid_a[i] = 0;
        valid_b[i] = 0;

        addr_a[i] = '0;
        addr_b[i] = '0;

    end

    // Generate Wavefront Addresses

    for(i=0; i<N; i++)
    begin


        if((cycle_count >= (i+1)) &&
           (cycle_count <= (i+N)))
        begin

            valid_a[i] = 1;

            addr_a[i] = i*N +
                        (cycle_count - (i+1));

        end


        if((cycle_count >= (i+1)) &&
           (cycle_count <= (i+N)))
        begin

            valid_b[i] = 1;

            addr_b[i] =
                ((cycle_count - (i+1))*N)
                + i;

        end

    end

end

endmodule
