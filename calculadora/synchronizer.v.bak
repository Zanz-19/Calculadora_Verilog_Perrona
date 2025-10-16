module synchronizer #(parameter WIDTH = 1) (
    input  wire clk,
    input  wire [WIDTH-1:0] async_in,
    output wire [WIDTH-1:0] sync_out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : GEN_SYNC
            reg d1, d2;
            always @(posedge clk) begin
                d1 <= async_in[i];
                d2 <= d1;
            end
            assign sync_out[i] = d2;
        end
    endgenerate
endmodule