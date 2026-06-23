`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 21:40:41
// Design Name: 
// Module Name: tiled_gemm_engine
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


module tiled_gemm_engine #(

    parameter int N           = 8,
    parameter int DATA_WIDTH  = 8,
    parameter int ACC_WIDTH   = 32,
    parameter int ADDR_WIDTH  = 32,
    parameter int DIM_WIDTH   = 16

)(

    input  logic clk,
    input  logic rst,

    input  logic start,

    input  logic [ADDR_WIDTH-1:0] a_tile_base,
    input  logic [ADDR_WIDTH-1:0] b_tile_base,

    input  logic [DIM_WIDTH-1:0] K,
    input  logic [DIM_WIDTH-1:0] P,

    output logic [ADDR_WIDTH-1:0] rd_addr_A,
    output logic [ADDR_WIDTH-1:0] rd_addr_B,

    input  logic signed [DATA_WIDTH-1:0] rd_data_A,
    input  logic signed [DATA_WIDTH-1:0] rd_data_B,

    output logic signed [ACC_WIDTH-1:0]
        c_tile [0:N-1][0:N-1],

    output logic done

);

    logic loader_done;

    logic tileA_wr_en;
    logic tileB_wr_en;

    logic [$clog2(N)-1:0] tileA_wr_row;
    logic [$clog2(N)-1:0] tileA_wr_col;

    logic [$clog2(N)-1:0] tileB_wr_row;
    logic [$clog2(N)-1:0] tileB_wr_col;

    logic signed [DATA_WIDTH-1:0] tileA_wr_data;
    logic signed [DATA_WIDTH-1:0] tileB_wr_data;

    logic signed [DATA_WIDTH-1:0]
        tile_A [0:N-1][0:N-1];

    logic signed [DATA_WIDTH-1:0]
        tile_B [0:N-1][0:N-1];

    logic wave_start;
    logic wave_done;

    logic loader_done_d;

    logic clear_acc;
    logic valid;

    logic signed [DATA_WIDTH-1:0]
        a_stream [0:N-1];

    logic signed [DATA_WIDTH-1:0]
        b_stream [0:N-1];

    tile_loader #(

        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DIM_WIDTH(DIM_WIDTH)

    ) loader (

        .clk(clk),
        .rst(rst),

        .start(start),

        .a_tile_base(a_tile_base),
        .b_tile_base(b_tile_base),

        .K(K),
        .P(P),

        .rd_addr_A(rd_addr_A),
        .rd_addr_B(rd_addr_B),

        .rd_data_A(rd_data_A),
        .rd_data_B(rd_data_B),

        .tileA_wr_en(tileA_wr_en),
        .tileB_wr_en(tileB_wr_en),

        .tileA_wr_row(tileA_wr_row),
        .tileA_wr_col(tileA_wr_col),

        .tileB_wr_row(tileB_wr_row),
        .tileB_wr_col(tileB_wr_col),

        .tileA_wr_data(tileA_wr_data),
        .tileB_wr_data(tileB_wr_data),

        .done(loader_done)

    );

    tile_buffer #(

        .N(N),
        .DATA_WIDTH(DATA_WIDTH)

    ) tile_buffer_A (

        .clk(clk),
        .rst(rst),

        .wr_en(tileA_wr_en),

        .wr_row(tileA_wr_row),
        .wr_col(tileA_wr_col),

        .wr_data(tileA_wr_data),

        .tile_data(tile_A)

    );

    tile_buffer #(

        .N(N),
        .DATA_WIDTH(DATA_WIDTH)

    ) tile_buffer_B (

        .clk(clk),
        .rst(rst),

        .wr_en(tileB_wr_en),

        .wr_row(tileB_wr_row),
        .wr_col(tileB_wr_col),

        .wr_data(tileB_wr_data),

        .tile_data(tile_B)

    );

    always_ff @(posedge clk)
    begin

        if(rst)
        begin

            loader_done_d <= 1'b0;
            wave_start    <= 1'b0;

        end

        else
        begin

            loader_done_d <= loader_done;

            wave_start <= loader_done &
                         ~loader_done_d;

        end

    end

    tile_wavefront_scheduler #(

        .N(N),
        .DATA_WIDTH(DATA_WIDTH)

    ) wave_ctrl (

        .clk(clk),
        .rst(rst),

        .start(wave_start),

        .tile_A(tile_A),
        .tile_B(tile_B),

        .a_stream(a_stream),
        .b_stream(b_stream),

        .valid(valid),
        .clear_acc(clear_acc),

        .done(wave_done)

    );

    systolic_array #(

        .N(N)

    ) sa (

        .clk(clk),
        .rst(rst),

        .clear_acc(clear_acc),
        .valid(valid),

        .a_in(a_stream),
        .b_in(b_stream),

        .c_out(c_tile)

    );

    assign done = wave_done;
    
always @(posedge clk)
begin

    if(loader_done)
    begin


        $display("");
        $display("====================================");
        $display("TILE A");
        $display("====================================");

        for(int r=0; r<N; r++)
        begin

            for(int c=0; c<N; c++)
            begin

                $write("%6d ", tile_A[r][c]);

            end

            $write("\n");

        end


        $display("");
        $display("====================================");
        $display("TILE B");
        $display("====================================");

        for(int r=0; r<N; r++)
        begin

            for(int c=0; c<N; c++)
            begin

                $write("%6d ", tile_B[r][c]);

            end

            $write("\n");

        end

        $display("====================================");
        $display("");

    end

end


endmodule