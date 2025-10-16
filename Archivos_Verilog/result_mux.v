module result_mux (
input wire [1:0] op_sel,
input wire signed [7:0] addsub_res,
input wire addsub_ovf,
input wire signed [7:0] muldiv_res,
input wire muldiv_err,
output reg signed [7:0] sel_res,
output reg ovf_flag,
output reg muldiv_err_flag
);
always @(*) begin
sel_res = 8'sd0;
ovf_flag = 1'b0;
muldiv_err_flag = 1'b0;
case (op_sel)
2'b00: begin sel_res = addsub_res; ovf_flag = addsub_ovf; end
2'b01: begin sel_res = addsub_res; ovf_flag = addsub_ovf; end
2'b10: begin sel_res = muldiv_res; muldiv_err_flag = muldiv_err; end
2'b11: begin sel_res = muldiv_res; muldiv_err_flag = muldiv_err; end
endcase
end
endmodule