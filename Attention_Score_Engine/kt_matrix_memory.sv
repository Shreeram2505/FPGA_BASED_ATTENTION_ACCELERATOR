module kt_matrix_memory #(

    parameter int MAX_SEQ   = 16,
    parameter int MAX_HEAD  = 16,
    parameter int DATA_WIDTH = 8

)(

    input logic clk,
    input logic rst,

    input logic load,

    input logic signed [DATA_WIDTH-1:0]
        matrix_in [0:MAX_HEAD-1][0:MAX_SEQ-1],

    output logic signed [DATA_WIDTH-1:0]
        matrix_out [0:MAX_HEAD-1][0:MAX_SEQ-1]

);

integer r;
integer c;

always_ff @(posedge clk)
begin

    if(rst)
    begin

        for(r=0; r<MAX_HEAD; r=r+1)
        begin
            for(c=0; c<MAX_SEQ; c=c+1)
            begin
                matrix_out[r][c] <= '0;
            end
        end

    end

    else if(load)
    begin

        for(r=0; r<MAX_HEAD; r=r+1)
        begin
            for(c=0; c<MAX_SEQ; c=c+1)
            begin
                matrix_out[r][c]
                    <= matrix_in[r][c];
            end
        end

    end

end

endmodule