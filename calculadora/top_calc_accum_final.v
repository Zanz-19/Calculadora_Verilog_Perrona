module top_calc_accum_final (
    input  wire clk,
    input  wire reset,
    input  wire [1:0] op_sel_raw,
    input  wire [7:0] data_in_raw,
    input  wire calc_btn_raw,

    output wire [6:0] disp0, // centésimas
    output wire [6:0] disp1, // décimas
    output wire [6:0] disp2, // unidades
    output wire [6:0] disp3, // decenas
    output wire [6:0] disp4, // centenas
    output wire neg_flag,
    output wire error_flag,
    output wire [7:0] acc_out
);

    // ----------------------
    // Internal wires
    // ----------------------
    wire [1:0] op_sel;
    wire [7:0] data_in;
    wire calc_pulse;
	 wire [6:0] frac_q;
    wire frac_err;


    wire op_add, op_sub, op_mul2, op_div2;
    wire signed [7:0] addsub_res;
    wire addsub_ovf;
    wire signed [7:0] muldiv_res;
    wire muldiv_err;
    wire signed [7:0] sel_res;
    wire ovf_from_mux, muldiv_err_from_mux;
    wire acc_write_en;
    wire signed [7:0] acc_q;

    wire [3:0] D4, D3, D2, D1, D0;

    // ----------------------
    // Synchronizers
    // ----------------------
    synchronizer #(.WIDTH(2)) sync_op(.clk(clk), .async_in(op_sel_raw), .sync_out(op_sel));
    synchronizer #(.WIDTH(8)) sync_data(.clk(clk), .async_in(data_in_raw), .sync_out(data_in));

    // ----------------------
    // Debounce
    // ----------------------
    debounce_button_shift #(.SAMPLES(8)) db(
        .clk(clk),
        .rst(reset),
        .btn_raw(calc_btn_raw),
        .btn_pulse(calc_pulse)
    );

    // ----------------------
    // ALUs
    // ----------------------
    wire op_add_local  = (op_sel == 2'b00);
    wire op_sub_local  = (op_sel == 2'b01);
    wire op_mul2_local = (op_sel == 2'b10);
    wire op_div2_local = (op_sel == 2'b11);

    alu_add_sub u_addsub(
        .a(acc_q),
        .b(data_in),
        .op_add(op_add_local),
        .result(addsub_res),
        .ovf(addsub_ovf)
    );

    alu_shift_mul2_div2 u_muldiv(
        .a(acc_q),
        .op_mul2(op_mul2_local),
        .result(muldiv_res),
        .err(muldiv_err)
    );
    // fraction manager: calcula next frac_q al presionar calc
    fraction_manager u_frac (
        .clk(clk),
        .rst(reset),
        .calc_pulse(calc_pulse),
        .op_sel(op_sel),
        .acc_int(acc_q),
        .data_in(data_in),
        .frac_q(frac_q),
        .frac_err(frac_err)
    );

    // ----------------------
    // Result mux
    // ----------------------
    result_mux u_mux(
        .op_sel(op_sel),
        .addsub_res(addsub_res),
        .addsub_ovf(addsub_ovf),
        .muldiv_res(muldiv_res),
        .muldiv_err(muldiv_err),
        .sel_res(sel_res),
        .ovf_flag(ovf_from_mux),
        .muldiv_err_flag(muldiv_err_from_mux)
    );

    // ----------------------
    // Overflow controller
    // ----------------------
    wire muldiv_err_combined = muldiv_err_from_mux | frac_err;

    overflow_controller u_ovf(
        .clk(clk),
        .rst(reset),
        .calc_pulse(calc_pulse),
        .ovf_in(ovf_from_mux),
        .muldiv_err_in(muldiv_err_combined),
        .accept_write(acc_write_en),
        .error_flag(error_flag)
    );


    // ----------------------
    // Accumulator
    // ----------------------
    accumulator u_acc(
        .clk(clk),
        .rst(reset),
        .load_en(acc_write_en),
        .d_in(sel_res),
        .acc_out(acc_q)
    );

    assign acc_out = acc_q;
    assign neg_flag = ~acc_q[7];

    // ----------------------
    // Binario -> Decimal con punto fijo y displays
    // ----------------------
    bin2decimal_fixed_combined u_b2d(
        .acc_int(acc_q),
        .frac(frac_q),
        .d4(D4), .d3(D3), .d2(D2), .d1(D1), .d0(D0),
        .sign()
    );


    display_driver_top u_displays(
        .d4(D4),
        .d3(D3),
        .d2(D2),
        .d1(D1),
        .d0(D0),
        .disp4(disp4),
        .disp3(disp3),
        .disp2(disp2),
        .disp1(disp1),
        .disp0(disp0)
    );

endmodule
