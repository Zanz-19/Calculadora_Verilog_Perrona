module debounce_button_shift #(parameter SAMPLES = 8) (
    input  wire clk,
    input  wire rst,      // síncrono
    input  wire btn_raw,  // entrada cruda (sin sincronizar)
    output reg  btn_pulse // pulso single-cycle
);
    // sincronizamos la entrada inmediatamente (2-flops) para evitar metastabilidad
    reg d1, d2;
    always @(posedge clk) begin
        d1 <= btn_raw;
        d2 <= d1;
    end

    reg [SAMPLES-1:0] shift;
    reg stable;
    reg prev_stable;

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            shift <= {SAMPLES{1'b0}};
            stable <= 1'b0;
            prev_stable <= 1'b0;
            btn_pulse <= 1'b0;
        end else begin
            // shift in the synchronized sample
            shift <= {shift[SAMPLES-2:0], d2};

            // update prev_stable first (hold previous stable)
            prev_stable <= stable;

            // determine new stable: only set when all bits equal 1 or all bits equal 0
            if (&shift) stable <= 1'b1;
            else if (~|shift) stable <= 1'b0;
            // else keep previous stable value (do not change)

            // pulse on rising edge (prev 0 -> stable 1)
            btn_pulse <= (prev_stable == 1'b0) && (stable == 1'b1);
        end
    end
endmodule
