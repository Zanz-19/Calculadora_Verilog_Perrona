module overflow_controller (
    input  wire clk,
    input  wire rst,
    input  wire calc_pulse,
    input  wire ovf_in,
    input  wire muldiv_err_in,
    output reg  accept_write,
    output reg  error_flag
);
    always @(posedge clk) begin
        if (rst) begin
            accept_write <= 1'b0;
            error_flag <= 1'b0;
        end else begin
            // default
            accept_write <= 1'b0;
            if (calc_pulse) begin
					 if (ovf_in || muldiv_err_in) begin
						  error_flag <= 1'b1;
						  accept_write <= 1'b0; // NO escribir en accumulator
								 end else begin
									  error_flag <= 1'b0;
									  accept_write <= 1'b1; // escribir resultado válido
								 end
							end
						else begin
                // maintain error_flag until next calc evaluated
                error_flag <= error_flag;
            end
        end
    end
endmodule