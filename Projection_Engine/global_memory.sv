`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 19:17:29
// Design Name: 
// Module Name: global_memory
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


module global_memory #(

    parameter int DATA_WIDTH = 8,
    parameter int MEM_DEPTH  = 4096,
    parameter int ADDR_WIDTH = 32,

    parameter string X_MEM_FILE  = "x.mem",
    parameter string WQ_MEM_FILE = "wq.mem",
    parameter string WK_MEM_FILE = "wk.mem",
    parameter string WV_MEM_FILE = "wv.mem"

)(

    //--------------------------------------------------
    // X Read Port
    //--------------------------------------------------

    input logic [ADDR_WIDTH-1:0] x_rd_addr,

    output logic signed [DATA_WIDTH-1:0]
        x_rd_data,

    //--------------------------------------------------
    // Weight Select
    //--------------------------------------------------

    input logic [1:0] weight_select,

    //--------------------------------------------------
    // Weight Read Port
    //--------------------------------------------------

    input logic [ADDR_WIDTH-1:0] weight_rd_addr,

    output logic signed [DATA_WIDTH-1:0]
        weight_rd_data

);

    //--------------------------------------------------
    // Memories
    //--------------------------------------------------

    logic signed [DATA_WIDTH-1:0]
        x_mem [0:MEM_DEPTH-1];

    logic signed [DATA_WIDTH-1:0]
        wq_mem [0:MEM_DEPTH-1];

    logic signed [DATA_WIDTH-1:0]
        wk_mem [0:MEM_DEPTH-1];

    logic signed [DATA_WIDTH-1:0]
        wv_mem [0:MEM_DEPTH-1];

    //--------------------------------------------------
    // Load Memory Files
    //--------------------------------------------------

    initial
    begin

        $display("--------------------------------");
        $display("Loading Matrix Memories");
        $display("--------------------------------");

        $readmemh(X_MEM_FILE,  x_mem);
        $readmemh(WQ_MEM_FILE, wq_mem);
        $readmemh(WK_MEM_FILE, wk_mem);
        $readmemh(WV_MEM_FILE, wv_mem);

        $display("Loaded X  from %s", X_MEM_FILE);
        $display("Loaded WQ from %s", WQ_MEM_FILE);
        $display("Loaded WK from %s", WK_MEM_FILE);
        $display("Loaded WV from %s", WV_MEM_FILE);

        $display("--------------------------------");

    end

    //--------------------------------------------------
    // X Read Port
    //--------------------------------------------------

    assign x_rd_data =
        x_mem[x_rd_addr];

    //--------------------------------------------------
    // Weight Read Mux
    //--------------------------------------------------

    always_comb
    begin

        case(weight_select)

            2'd0:
                weight_rd_data =
                    wq_mem[weight_rd_addr];

            2'd1:
                weight_rd_data =
                    wk_mem[weight_rd_addr];

            2'd2:
                weight_rd_data =
                    wv_mem[weight_rd_addr];

            default:
                weight_rd_data = '0;

        endcase

    end

endmodule