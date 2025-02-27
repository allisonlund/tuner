module hex2ssd
  (input [3:0] hex_i
  ,output [6:0] ssd_o
  );

  logic [6:0] ssd_l;

  always_comb begin
    ssd_l[6:0] = 7'b1111111;
    case (hex_i)
      4'b0000: ssd_l[6:0] = 7'b0001000;
      4'b0001: ssd_l[6:0] = 7'b0000011;
      4'b0010: ssd_l[6:0] = 7'b0000110;
      4'b0011: ssd_l[6:0] = 7'b0100001;
      4'b0100: ssd_l[6:0] = 7'b0000110;
      4'b0101: ssd_l[6:0] = 7'b0001110;
      4'b0110: ssd_l[6:0] = 7'b0010000;
      default: ssd_l[6:0] = 7'b1111111;  
    endcase

  end

  assign ssd_o[6:0] = ssd_l[6:0];

endmodule
