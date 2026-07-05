`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 18:18:31
// Design Name: 
// Module Name: softmax_engine
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


module softmax_engine #(

    parameter int MAX_SEQ       = 16,
    parameter int DATA_WIDTH    = 32,
    parameter int EXP_WIDTH     = 16,
    parameter int RECIP_WIDTH   = 16,
    parameter int SOFTMAX_WIDTH = 16

)(

    input logic clk,
    input logic rst,
    input logic start,

    input logic [15:0] seq_len,



    input logic signed [DATA_WIDTH-1:0]
        scaled_score_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],


    output logic [SOFTMAX_WIDTH-1:0]
        softmax_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1],

    output logic done

);

logic signed [DATA_WIDTH-1:0]
    current_row [0:MAX_SEQ-1];

logic signed [DATA_WIDTH-1:0]
    shifted_row [0:MAX_SEQ-1];

logic [EXP_WIDTH-1:0]
    exp_row_data [0:MAX_SEQ-1];

logic [EXP_WIDTH-1:0]
    exp_matrix [0:MAX_SEQ-1][0:MAX_SEQ-1];

logic [RECIP_WIDTH-1:0]
    reciprocal [0:MAX_SEQ-1];

logic signed [DATA_WIDTH-1:0]
    row_max;

logic [31:0]
    row_sum_value;

logic reciprocal_valid;

logic normalizer_done;

logic reciprocal_enable;

logic normalizer_start;

logic [RECIP_WIDTH-1:0]
    reciprocal_value;

integer r;
integer c;

logic [15:0] row_index;

row_max_finder max_finder(

    .row_data(current_row),
    .seq_len(seq_len),
    .row_max(row_max)

);

subtract_max subtract(

    .row_data(current_row),
    .row_max(row_max),
    .shifted_row(shifted_row)

);

exp_row exponent(

    .shifted_row(shifted_row),
    .exp_row(exp_row_data)

);

row_sum sum(

    .exp_row(exp_row_data),
    .seq_len(seq_len),
    .row_sum(row_sum_value)

);

reciprocal_lut recip(

    .clk(clk),
    .rst(rst),

    .enable(reciprocal_enable),

    .row_sum(row_sum_value),

    .reciprocal(reciprocal_value),

    .valid(reciprocal_valid)

);

softmax_normalizer normalizer(

    .clk(clk),
    .rst(rst),

    .start(normalizer_start),

    .exp_matrix(exp_matrix),

    .reciprocal(reciprocal ),

    .softmax_matrix(softmax_matrix),

    .done(normalizer_done)

);

typedef enum logic[3:0]
{

    IDLE,

    LOAD_ROW,

    WAIT_ROW,

    COMPUTE_ROW,

    NEXT_ROW,

    NORMALIZE,
    
    WAIT_NORMALIZER,

    DONE

} state_t;

state_t state;

always_ff @(posedge clk)
begin

    if(rst)
begin

    state<=IDLE;

    row_index<=0;

    reciprocal_enable<=0;

    normalizer_start<=0;

    done<=0;

    for(r=0;r<MAX_SEQ;r=r+1)
    begin

        reciprocal[r] <= 0;

        for(c=0;c<MAX_SEQ;c=c+1)
        begin

            exp_matrix[r][c] <= 0;

            softmax_matrix[r][c] <= 0;

        end

    end

end
    else
    begin

        reciprocal_enable <= 0;
        normalizer_start <= 0;
        done <= 0;

        case(state)

        //------------------------------------

        IDLE:
        begin

            if(start)
            begin

                row_index <= 0;

                state <= LOAD_ROW;

            end

        end

        //------------------------------------

    LOAD_ROW:
begin

    for(c=0;c<seq_len;c=c+1)
        current_row[c]
            <= scaled_score_matrix[row_index][c];

    $display("");
    $display("==============================");
    $display("ROW %0d LOADED",row_index);
    $display("==============================");

    for(int i=0;i<seq_len;i++)
        $write("%0d ",scaled_score_matrix[row_index][i]);

    $display("");

    state <= WAIT_ROW;

end

        WAIT_ROW:
        begin

            state <= COMPUTE_ROW;

        end

        //------------------------------------

        COMPUTE_ROW:
        begin

            for(c=0; c<seq_len; c=c+1)
                exp_matrix[row_index][c]
                    <= exp_row_data[c];
                  
        $display("ROW MAX = %0d",row_max);

        $display("SHIFTED ROW");

        for(int i=0;i<seq_len;i++)
            $write("%0d ",shifted_row[i]);

        $display("");

        $display("EXP ROW");

       for(int i=0;i<seq_len;i++)
            $write("%0d ",exp_row_data[i]);

        $display("");

        $display("ROW SUM = %0d",row_sum_value);
            reciprocal_enable <= 1;

            state <= NEXT_ROW;

        end
        

        //------------------------------------

    NEXT_ROW:
begin

    if(reciprocal_valid)
    begin
        $display("RECIPROCAL = %0d",reciprocal_value);
        reciprocal[row_index] <= reciprocal_value;

                if(row_index>=seq_len-1)

                    state <= NORMALIZE;

                else
                begin

                    row_index <= row_index + 1;

                    state <= LOAD_ROW;

                end

            end

        end
        //------------------------------------

    NORMALIZE:
begin

$display("");
$display("==============================");
$display("EXP MATRIX");
$display("==============================");

for(int r=0;r<seq_len;r++)
begin

    for(int c=0;c<seq_len;c++)
        $write("%0d ",exp_matrix[r][c]);

    $write("\n");

end

$display("");

$display("RECIPROCAL ARRAY");

for(int i=0;i<seq_len;i++)
    $write("%0d ",reciprocal[i]);

$display("");
    normalizer_start <= 1;

    state <= WAIT_NORMALIZER;

end

    WAIT_NORMALIZER:
begin

    normalizer_start <= 0;

    if(normalizer_done)

        state <= DONE;

end

        //------------------------------------

        DONE:
        begin

            done <= 1;

            state <= IDLE;

        end

        //------------------------------------

        endcase

    end

end
endmodule
