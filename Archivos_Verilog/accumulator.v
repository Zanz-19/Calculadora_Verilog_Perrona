module accumulator (
    input  wire clk,
    input  wire rst,
    input  wire load_en,
    input  wire signed [7:0] d_in,
    output reg  signed [7:0] acc_out
);
    always @(posedge clk) begin
        if (rst) acc_out <= 8'sd0;
        else if (load_en) acc_out <= d_in;
        else acc_out <= acc_out;
    end
endmodule