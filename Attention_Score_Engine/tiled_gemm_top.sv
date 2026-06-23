`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 21:49:04
// Design Name: 
// Module Name: tiled_gemm_top
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


module top_tiled_gemm #(

    parameter int N           = 8,
    parameter int DATA_WIDTH  = 8,
    parameter int ACC_WIDTH   = 32,
    parameter int ADDR_WIDTH  = 32,
    parameter int DIM_WIDTH   = 16,

    parameter int MAX_M       = 16,
    parameter int MAX_P       = 16

)(

    input logic clk,
    input logic rst,
    input logic start,

    input logic [DIM_WIDTH-1:0] M,
    input logic [DIM_WIDTH-1:0] K,
    input logic [DIM_WIDTH-1:0] P,

    output logic [ADDR_WIDTH-1:0] rd_addr_A,
    output logic [ADDR_WIDTH-1:0] rd_addr_B,

    input logic signed [DATA_WIDTH-1:0] rd_data_A,
    input logic signed [DATA_WIDTH-1:0] rd_data_B,

    output logic signed [ACC_WIDTH-1:0]
        c_matrix [0:MAX_M-1][0:MAX_P-1],

    output logic done

);



    logic [DIM_WIDTH-1:0] tile_m;
    logic [DIM_WIDTH-1:0] tile_n;
    logic [DIM_WIDTH-1:0] tile_k;

    logic issue_tile;
    logic scheduler_done;



    logic [ADDR_WIDTH-1:0] a_tile_base;
    logic [ADDR_WIDTH-1:0] b_tile_base;
    logic [ADDR_WIDTH-1:0] c_tile_base;



    logic engine_done;

    logic signed [ACC_WIDTH-1:0]
        engine_tile [0:N-1][0:N-1];



    logic accumulate;
    logic clear_result;

    logic signed [ACC_WIDTH-1:0]
        accumulated_tile [0:N-1][0:N-1];

    logic signed [ACC_WIDTH-1:0]
        full_c_matrix [0:MAX_M-1][0:MAX_P-1];
    
    logic write_c_tile;
    logic write_c_tile_d;

    logic [DIM_WIDTH-1:0] tile_m_d;
    logic [DIM_WIDTH-1:0] tile_n_d;

    // Tile Scheduler


    tile_scheduler #(

        .TILE_SIZE(N),
        .DIM_WIDTH(DIM_WIDTH)

    ) scheduler (

        .clk(clk),
        .rst(rst),

        .start(start),

        .tile_done(engine_done),

        .M(M),
        .K(K),
        .P(P),

        .tile_m(tile_m),
        .tile_n(tile_n),
        .tile_k(tile_k),

        .issue_tile(issue_tile),

        .done(scheduler_done)

    );

    // Tile Address Generator

    tile_address_generator #(

        .TILE_SIZE(N),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DIM_WIDTH(DIM_WIDTH)

    ) addr_gen (

        .K(K),
        .P(P),

        .tile_m(tile_m),
        .tile_n(tile_n),
        .tile_k(tile_k),

        .a_tile_base(a_tile_base),
        .b_tile_base(b_tile_base),
        .c_tile_base(c_tile_base)

    );

    // Tile GEMM Engine

    tiled_gemm_engine #(

        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DIM_WIDTH(DIM_WIDTH)

    ) engine (

        .clk(clk),
        .rst(rst),

        .start(issue_tile),

        .a_tile_base(a_tile_base),
        .b_tile_base(b_tile_base),

        .K(K),
        .P(P),

        .rd_addr_A(rd_addr_A),
        .rd_addr_B(rd_addr_B),

        .rd_data_A(rd_data_A),
        .rd_data_B(rd_data_B),

        .c_tile(engine_tile),

        .done(engine_done)

    );



    assign clear_result =
    issue_tile &&
    (tile_k == 0);
    

    // Accumulate Every Completed Tile

    assign accumulate = engine_done;
    
    assign write_c_tile =
    engine_done &&
    (tile_k == (((K + N - 1)/N) - 1));

always_ff @(posedge clk)
begin

    if(rst)
    begin

        write_c_tile_d <= 0;

        tile_m_d <= 0;
        tile_n_d <= 0;

    end
    else
    begin

        write_c_tile_d <= write_c_tile;

        tile_m_d <= tile_m;
        tile_n_d <= tile_n;

    end

end

    //--------------------------------------------------
    // Result Buffer
    //--------------------------------------------------

    result_buffer #(

        .N(N),
        .ACC_WIDTH(ACC_WIDTH)

    ) result_mem (

        .clk(clk),
        .rst(rst),

        .clear(clear_result),

        .accumulate(accumulate),

        .c_tile_in(engine_tile),

        .c_tile_out(accumulated_tile)

    );
    
c_matrix_memory #(

    .N(N),
    .MAX_M(MAX_M),
    .MAX_P(MAX_P),
    .ACC_WIDTH(ACC_WIDTH),
    .DIM_WIDTH(DIM_WIDTH)

) c_mem (

    .clk(clk),
    .rst(rst),

    .write_tile(write_c_tile_d),

    .tile_m(tile_m_d),
    .tile_n(tile_n_d),

    .tile_data(accumulated_tile),

    .c_matrix(full_c_matrix)

);


genvar r;
genvar c;

generate

    for(r=0; r<MAX_M; r=r+1)
    begin : OUT_R

        for(c=0; c<MAX_P; c=c+1)
        begin : OUT_C

            assign c_matrix[r][c]
                = full_c_matrix[r][c];

        end

    end

endgenerate

assign done = scheduler_done;

always @(posedge clk)
begin

    if(engine_done)
    begin

        $display("");
        $display("====================================");
        $display(
        "ENGINE DONE -> tile_m=%0d tile_n=%0d tile_k=%0d",
        tile_m,
        tile_n,
        tile_k
        );

        $display(
        "clear_result=%0d accumulate=%0d",
        clear_result,
        accumulate
        );

        $display("ENGINE TILE");

        for(int rr=0; rr<N; rr++)
        begin

            for(int cc=0; cc<N; cc++)
            begin

                $write("%8d ",
                    engine_tile[rr][cc]);

            end

            $write("\n");

        end

        $display("====================================");
        $display("");

    end

end

always @(posedge clk)
begin

    if(write_c_tile_d)
    begin

        $display(
        "WRITE C TILE -> tile_m=%0d tile_n=%0d",
        tile_m_d,
        tile_n_d
        );

    end

end

endmodule
