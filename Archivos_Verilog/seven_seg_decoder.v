module seven_seg_decoder #(parameter ACTIVE_LOW = 1) (
    input  wire [3:0] digit, // 0..9, 10='-', 11 blank
    output reg  [6:0] seg_out // {a,b,c,d,e,f,g}
);
    reg [6:0] seg_high; // active-high mapping
    always @(*) begin
        case (digit)
            4'd0: seg_high = 7'b1111110;
            4'd1: seg_high = 7'b0110000;
            4'd2: seg_high = 7'b1101101;
            4'd3: seg_high = 7'b1111001;
            4'd4: seg_high = 7'b0110011;
            4'd5: seg_high = 7'b1011011;
            4'd6: seg_high = 7'b1011111;
            4'd7: seg_high = 7'b1110000;
            4'd8: seg_high = 7'b1111111;
            4'd9: seg_high = 7'b1111011;
            4'd10: seg_high = 7'b0000001; // '-'
            default: seg_high = 7'b0000000; // blank
        endcase
    end

    always @(*) begin
        if (ACTIVE_LOW)
            seg_out = ~seg_high; // invert mapping for active-low displays
        else
            seg_out = seg_high;
    end
endmodule
