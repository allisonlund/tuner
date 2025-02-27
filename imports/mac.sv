module mac
 #(parameter int_in_lp = 1
  ,parameter frac_in_lp = 11
  ,parameter int_out_lp = 10
  ,parameter frac_out_lp = 22
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [int_in_lp - 1 : -frac_in_lp] a_i
  ,input [int_in_lp - 1 : -frac_in_lp] b_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,input [0:0] ready_i
  ,output [0:0] valid_o 
  ,output [int_out_lp - 1 : -frac_out_lp] data_o
  );

  logic signed [int_out_lp - 1 : -frac_out_lp] data_current_l;

  logic [0:0] valid_ol; 

 always_ff @(posedge clk_i) begin 

    if(reset_i) begin
      data_current_l <= 0;
      valid_ol <= 0;
    end
    else if(valid_i && ready_o) begin
      data_current_l <= ($signed(a_i) * $signed(b_i)) + $signed(data_current_l);
      valid_ol <= 1;
    end
    else if (ready_i) begin
      valid_ol <= 0;
    end
  end

  assign data_o = data_current_l;
  assign valid_o = valid_ol;
  assign ready_o = ~valid_ol;


endmodule